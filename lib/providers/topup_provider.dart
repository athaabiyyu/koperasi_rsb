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
  
  // ✅ TAMBAHAN: Getter untuk cek apakah data kosong tapi valid (bukan error)
  bool get hasNoTransactions => !_isLoading && _topups.isEmpty && _errorMessage == null;

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

  // Submit Simpanan Wajib
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
        } catch (e) {
        }

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
// ✅ IMPROVED: Fetch topup history dengan handling yang lebih baik
Future<bool> fetchTopupHistory(String token) async {
  setLoading(true);
  clearError(); // ✅ Clear error sebelum fetch

  try {
    // ✅ FIX: Buat instance dari TopupService
    final topupService = TopupService();
    final result = await topupService.getTopupByUserId(token);
    
    if (result['success'] == true) {
      // ✅ Handle data bisa berupa List langsung atau nested dalam object
      final data = result['data'];
      
      if (data is List<TopupModel>) {
        _topups = data;
      } else if (data is List) {
        _topups = data.cast<TopupModel>();
      } else {
        // Jika data bukan list, set empty
        _topups = [];
      }
      
      // ✅ PENTING: Clear error jika berhasil, meskipun data kosong
      _errorMessage = null;
      
      setLoading(false);
      notifyListeners();
      return true;
    } else {
      // ✅ Hanya set error jika memang ada error dari API
      final errorMsg = result['message'] ?? 'Gagal mengambil riwayat topup';
      print('❌ Error: $errorMsg');
      
      // ✅ Jika error message adalah "no topups found", jangan anggap sebagai error
      if (errorMsg.toLowerCase().contains('no topups') || 
          errorMsg.toLowerCase().contains('tidak ada') ||
          errorMsg.toLowerCase().contains('belum ada')) {
        _topups = [];
        _errorMessage = null; 
        _errorMessage = errorMsg;
      }
      
      setLoading(false);
      notifyListeners();
      return false;
    }
  } catch (e) {
    print('❌ Exception: $e');
    
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('no topups') || 
        errorString.contains('not found') ||
        errorString.contains('empty')) {
      _topups = [];
      _errorMessage = null; // Bukan error, hanya kosong
    } else {
      _errorMessage = 'Terjadi kesalahan: $e';
    }
    
    setLoading(false);
    notifyListeners();
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