import 'package:flutter/material.dart';
import 'package:koperasi_rsb/services/topup_service.dart';
import 'package:intl/intl.dart';

class WalletProvider with ChangeNotifier {
  double _saldoTopup = 0.0;
  double _simpananWajib = 0.0;
  double _simpananPokok = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  double get saldoTopup => _saldoTopup;
  double get simpananWajib => _simpananWajib;
  double get simpananPokok => _simpananPokok;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Formatted getters (dengan format Rupiah)
  String get formattedSaldoTopup {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(_saldoTopup);
  }

  String get formattedSimpananWajib {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(_simpananWajib);
  }

  String get formattedSimpananPokok {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(_simpananPokok);
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

  // Fetch ALL wallet saldo from backend (3 separate API calls)
  Future<bool> fetchWalletSaldo(String token, String userId) async {
    setLoading(true);
    setError(null);

    try {
      
      // Fetch semua saldo secara parallel untuk performa lebih baik
      final results = await Future.wait([
        TopupService.getSaldoTopup(token),
        TopupService.getSimpananWajib(token),
        TopupService.getSimpananPokok(token),
      ]);

      // Parse hasil dari setiap endpoint
      final saldoTopupResult = results[0];
      final simpananWajibResult = results[1];
      final simpananPokokResult = results[2];

      // Update saldo topup
      if (saldoTopupResult['success'] == true) {
        _saldoTopup = _parseDouble(saldoTopupResult['total']);
      } else {
        _saldoTopup = 0.0;
      }

      // Update simpanan wajib
      if (simpananWajibResult['success'] == true) {
        _simpananWajib = _parseDouble(simpananWajibResult['total']);
      } else {
        _simpananWajib = 0.0;
      }

      // Update simpanan pokok
      if (simpananPokokResult['success'] == true) {
        _simpananPokok = _parseDouble(simpananPokokResult['total']);
      } else {
        _simpananPokok = 0.0;
      }
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      return false;
    }
  }

  // Fetch individual saldo (optional, jika perlu fetch satu per satu)
  Future<bool> fetchSaldoTopup(String token) async {
    try {
      final result = await TopupService.getSaldoTopup(token);
      if (result['success'] == true) {
        _saldoTopup = _parseDouble(result['total']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchSimpananWajib(String token) async {
    try {
      final result = await TopupService.getSimpananWajib(token);
      if (result['success'] == true) {
        _simpananWajib = _parseDouble(result['total']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchSimpananPokok(String token) async {
    try {
      final result = await TopupService.getSimpananPokok(token);
      if (result['success'] == true) {
        _simpananPokok = _parseDouble(result['total']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Helper function untuk parse double dari berbagai tipe data
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Refresh wallet saldo
  Future<void> refreshWalletSaldo(String token, String userId) async {
    await fetchWalletSaldo(token, userId);
  }

  // Clear wallet data (for logout)
  void clearWalletData() {
    _saldoTopup = 0.0;
    _simpananWajib = 0.0;
    _simpananPokok = 0.0;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update specific saldo (optional, jika ada transaksi lokal)
  void updateSaldoTopup(double amount) {
    _saldoTopup = amount;
    notifyListeners();
  }

  void updateSimpananWajib(double amount) {
    _simpananWajib = amount;
    notifyListeners();
  }

  void updateSimpananPokok(double amount) {
    _simpananPokok = amount;
    notifyListeners();
  }

  // Add amount to saldo (untuk simulasi topup berhasil)
  void addToSaldoTopup(double amount) {
    _saldoTopup += amount;
    notifyListeners();
  }
}