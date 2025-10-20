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
      print('❌ Error fetching topup history: $e');
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
      print('❌ Error getting topup detail: $e');
      return null;
    }
  }
}