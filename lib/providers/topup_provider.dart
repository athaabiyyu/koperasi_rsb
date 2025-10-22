import 'dart:io';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/models/topup_model.dart';
import 'package:koperasi_rsb/services/topup_service.dart';

class TopupProvider with ChangeNotifier {
  List<TopupModel> _topups = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TopupModel> get topups => _topups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasTopups => _topups.isNotEmpty;

  // Get pending topup (for "Bayar Simpanan Wajib" button)
  TopupModel? get pendingTopup {
    try {
      return _topups.firstWhere((topup) => topup.isPending);
    } catch (e) {
      return null;
    }
  }

  // Setters
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Tambahkan method baru di class TopupProvider
  Future<Map<String, dynamic>> submitSimpananWajib({
    required String token,
    required String namaBank,
    required String noRekening,
    required String namaPemilikRekening,
    required File buktiPembayaran,
  }) async {
    setLoading(true);
    setError(null);

    try {
      if (token.isEmpty) {
        throw Exception('Token tidak valid atau kosong');
      }

      if (!buktiPembayaran.existsSync()) {
        throw Exception('File bukti pembayaran tidak ditemukan');
      }

      final result = await TopupService.paySimpananWajib(
        token: token,
        namaBank: namaBank,
        noRekening: noRekening,
        namaPemilikRekening: namaPemilikRekening,
        buktiPembayaran: buktiPembayaran,
      );

      setLoading(false);

      if (result['success'] == true) {
        // Refresh topup history setelah submit
        try {
          await fetchTopupHistory(token);
        } catch (e) {
          print('Error refreshing history: $e');
        }

        return {
          'success': true,
          'message': result['message'] ?? 'Simpanan wajib berhasil diajukan',
        };
      } else {
        setError(result['message']);
        return {
          'success': false,
          'message': result['message'] ?? 'Gagal mengajukan simpanan wajib',
        };
      }
    } catch (e) {
      setLoading(false);
      setError('Terjadi kesalahan: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // ✅ SUBMIT TOPUP PAYMENT
  Future<Map<String, dynamic>> submitTopup({
    required String token,
    required String namaBank,
    required String noRekening,
    required String namaPemilikRekening,
    required int nominal,
    required File buktiPembayaran,
  }) async {
    setLoading(true);
    setError(null);

    try {
      // Validate token
      if (token.isEmpty) {
        throw Exception('Token tidak valid atau kosong');
      }

      // Validate file
      if (!buktiPembayaran.existsSync()) {
        throw Exception('File bukti pembayaran tidak ditemukan');
      }

      final result = await TopupService.payTopup(
        token: token,
        namaBank: namaBank,
        noRekening: noRekening,
        namaPemilikRekening: namaPemilikRekening,
        nominal: nominal,
        buktiPembayaran: buktiPembayaran,
      );

      setLoading(false);

      if (result['success'] == true) {
        // ✅ Refresh topup history setelah submit
        try {
          await fetchTopupHistory(token);
        } catch (e) {}

        return {
          'success': true,
          'message': result['message'] ?? 'Topup berhasil diajukan',
        };
      } else {
        setError(result['message']);
        return {
          'success': false,
          'message': result['message'] ?? 'Gagal mengajukan topup',
        };
      }
    } catch (e) {
      setLoading(false);
      setError('Terjadi kesalahan: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Fetch topup history
  Future<bool> fetchTopupHistory(String token) async {
    setLoading(true);
    setError(null);

    try {
      final result = await TopupService.getTopupByUserId(token);
      if (result['success'] == true) {
        _topups = result['data'] as List<TopupModel>;
        setLoading(false);
        notifyListeners();
        return true;
      } else {
        setError(result['message'] ?? 'Gagal mengambil riwayat topup');
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      return false;
    }
  }

  // Refresh topup history
  Future<void> refreshTopupHistory(String token) async {
    await fetchTopupHistory(token);
  }

  // Clear topup data (for logout)
  void clearTopupData() {
    _topups = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Get topup by ID (optional, for detail view)
  Future<TopupModel?> getTopupById(String token, String topupId) async {
    try {
      final result = await TopupService.getTopupById(token, topupId);
      if (result['success'] == true) {
        return result['data'] as TopupModel;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
