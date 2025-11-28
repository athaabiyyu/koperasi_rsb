import 'dart:async';
import 'package:flutter/material.dart';
import '../models/token_usage_model.dart';
import '../services/token_service.dart';
import 'package:koperasi_rsb/utils/notification_service.dart';
import 'package:koperasi_rsb/utils/app_notifier_dialog.dart';
import 'package:koperasi_rsb/utils/app_navigator.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'wallet_provider.dart';
import 'project_provider.dart';

class TokenProvider extends ChangeNotifier {
  final TokenService _tokenService = TokenService();

  // Token usage details state
  List<TokenUsageDetail> _tokenUsageList = [];
  bool _isLoadingUsage = false;
  String? _usageError;

  // Buy token state (single-source of truth)
  bool _isBuyingToken = false;
  String? _buyTokenError;
  String? _buyTokenSuccess;
  Timer? _autoClearTimer; // mencegah tabrakan clear antar halaman & provider

  // Getters
  List<TokenUsageDetail> get tokenUsageList => _tokenUsageList;
  bool get isLoadingUsage => _isLoadingUsage;
  String? get usageError => _usageError;
  bool get isBuyingToken => _isBuyingToken;
  String? get buyTokenError => _buyTokenError;
  String? get buyTokenSuccess => _buyTokenSuccess;

  /// Load token usage details for authenticated user
  Future<void> loadTokenUsageDetails(String token) async {
    try {
      _isLoadingUsage = true;
      _usageError = null;
      notifyListeners();

      _tokenUsageList = await _tokenService.getTokenUsageDetails(token);

      _isLoadingUsage = false;
      notifyListeners();
    } catch (e) {
      _isLoadingUsage = false;

      // Parse error message
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Check if this is "no data" error (404 with specific message)
      if (errorMessage.contains('No token usage details found') ||
          errorMessage.contains('no token usage details found') ||
          errorMessage.contains('tidak ditemukan') ||
          errorMessage.toLowerCase().contains('not found')) {
        // This is NOT an error - user just doesn't have any tokens yet
        // Set empty list and no error
        _tokenUsageList = [];
        _usageError = null;
      } else {
        // This is a real error (network, server, etc)
        _usageError = _formatErrorMessage(errorMessage);
        _tokenUsageList = [];
      }

      notifyListeners();
    }
  }

  /// Format error message to be more user-friendly
  String _formatErrorMessage(String error) {
    if (error.contains('SocketException') ||
        error.contains('Failed host lookup')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (error.contains('TimeoutException')) {
      return 'Koneksi timeout. Silakan coba lagi.';
    } else if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Sesi Anda telah berakhir. Silakan login kembali.';
    } else if (error.contains('500') ||
        error.contains('Internal Server Error')) {
      return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
    } else if (error.contains('Gagal memuat')) {
      // Remove redundant prefix
      return error.replaceAll('Gagal memuat token usage details: ', '');
    }

    return error;
  }

  /// Clear token usage cache
  void clearTokenUsage() {
    _tokenUsageList = [];
    _isLoadingUsage = false;
    _usageError = null;
    notifyListeners();
  }

  /// Get top 3 recent token usage
  List<TokenUsageDetail> getTopTokenUsage({int limit = 3}) {
    if (_tokenUsageList.length <= limit) {
      return _tokenUsageList;
    }
    return _tokenUsageList.take(limit).toList();
  }

  /// Get token usage by status
  List<TokenUsageDetail> getTokenUsageByStatus(String status) {
    return _tokenUsageList
        .where((usage) => usage.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Get total tokens used
  int getTotalTokensUsed() {
    return _tokenUsageList.fold<int>(
      0,
      (sum, usage) => sum + usage.tokenCountInt,
    );
  }

  /// Get total nominal invested
  int getTotalNominalInvested() {
    return _tokenUsageList.fold<int>(
      0,
      (sum, usage) => sum + usage.totalNominalInt,
    );
  }

  /// Buy token for a project
  Future<bool> buyToken({
    required String token,
    required String projectId,
    required int jumlahToken,
    required String projectName,
    bool autoClear = true,
    bool refreshGlobal =
        true, // refresh dashboard & project lists after success
  }) async {
    try {
      // Batalkan timer sebelumnya jika user melakukan pembelian baru sebelum clear selesai
      _autoClearTimer?.cancel();
      _isBuyingToken = true;
      _buyTokenError = null;
      _buyTokenSuccess = null;
      notifyListeners();

      final result = await _tokenService.buyToken(
        token: token,
        projectId: projectId,
        jumlahToken: jumlahToken,
      );

      _isBuyingToken = false;

      if (result['success'] == true) {
        _buyTokenSuccess = result['message'];
        notifyListeners();

        // Refresh token usage list (silent)
        await loadTokenUsageDetails(token);

        // Local device notification (tidak tergantung halaman yang sedang aktif)
        try {
          NotificationService().showPurchaseSuccess(
            jumlahToken: jumlahToken,
            projectName: projectName,
          );
        } catch (e) {
          debugPrint('Gagal menampilkan notifikasi lokal: $e');
        }

        // Dialog (in-app) notification menggunakan global navigator
        try {
          await AppNotifierDialog.success(
            message: _buyTokenSuccess ?? 'Pembelian token berhasil',
          );
        } catch (e) {
          debugPrint('Gagal menampilkan dialog sukses: $e');
        }

        // Jadwalkan auto-clear agar banner tidak nempel di halaman lain
        if (autoClear) {
          _autoClearTimer = Timer(const Duration(seconds: 3), () {
            // Pastikan tidak ada proses pembelian baru sebelum clear
            if (!_isBuyingToken && _buyTokenSuccess != null) {
              clearBuyTokenMessages();
            }
          });
        }

        // Refresh global data (dashboard, lists, wallet) tanpa bergantung halaman detail
        if (refreshGlobal) {
          final ctx = AppNavigator.key.currentContext;
          if (ctx != null) {
            Future(() async {
              try {
                final projectProv = Provider.of<ProjectProvider>(
                  ctx,
                  listen: false,
                );
                // Refresh project detail & investors for the purchased project
                await projectProv.getProjectDetail(projectId);
                // Refresh user and public project lists
                await projectProv.loadUserProjects();
                await projectProv.loadAllProjects();
              } catch (e) {
                debugPrint('Refresh project provider failed: $e');
              }
              try {
                final authProv = Provider.of<AuthProvider>(ctx, listen: false);
                final walletProv = Provider.of<WalletProvider>(
                  ctx,
                  listen: false,
                );
                if (authProv.token != null && authProv.userId != null) {
                  await walletProv.fetchWalletSaldo(
                    authProv.token!,
                    authProv.userId!,
                  );
                }
              } catch (e) {
                debugPrint('Refresh wallet after purchase failed: $e');
              }
            });
          } else {
            debugPrint(
              'Global context not available for refresh after purchase',
            );
          }
        }
        return true;
      } else {
        _buyTokenError = result['message'];
        notifyListeners();
        // Dialog error
        try {
          await AppNotifierDialog.error(
            message: _buyTokenError ?? 'Gagal membeli token',
          );
        } catch (e) {
          debugPrint('Gagal menampilkan dialog error: $e');
        }
        if (autoClear) {
          _autoClearTimer = Timer(const Duration(seconds: 3), () {
            if (!_isBuyingToken && _buyTokenError != null) {
              clearBuyTokenMessages();
            }
          });
        }
        return false;
      }
    } catch (e) {
      _isBuyingToken = false;
      _buyTokenError = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();
      _autoClearTimer?.cancel();
      _autoClearTimer = Timer(const Duration(seconds: 3), () {
        if (!_isBuyingToken && _buyTokenError != null) {
          clearBuyTokenMessages();
        }
      });
      try {
        await AppNotifierDialog.error(
          message: _buyTokenError ?? 'Terjadi kesalahan',
        );
      } catch (e) {
        debugPrint('Gagal menampilkan dialog exception: $e');
      }
      return false;
    }
  }

  /// Clear buy token messages
  void clearBuyTokenMessages() {
    _autoClearTimer?.cancel();
    _buyTokenError = null;
    _buyTokenSuccess = null;
    notifyListeners();
  }
}
