import 'package:flutter/material.dart';
import 'package:koperasi_rsb/models/payment-member_model.dart';
import 'package:koperasi_rsb/utils/shared_preferences_helper.dart';
import 'package:koperasi_rsb/services/auth_service.dart';
import 'package:koperasi_rsb/services/user_services.dart';

class UserProvider with ChangeNotifier {
  String? _errorMessage;
  String? _userName;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  final UserService _userService = UserService();

  // Getters
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

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

  // Fetch user profile menggunakan UserService
  Future<void> fetchUserProfile({
    required String userId,
    required String token,
  }) async {
    try {
      print('🔄 Fetching user profile for ID: $userId');
      
      final result = await _userService.getUserById(
        userId: userId,
        token: token,
      );

      if (result['success'] == true && result['data'] != null) {
        _userProfile = result['data'];
        _userName = _userProfile!['nama'];
        
        // Save nama ke SharedPreferences untuk persistence
        if (_userName != null) {
          await SharedPreferencesHelper.saveUserName(_userName!);
        }
        
        print('✅ User profile fetched successfully');
        print('   Name: $_userName');
        notifyListeners();
      } else {
        print('⚠️ Failed to fetch profile: ${result['message']}');
        setError(result['message']);
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      setError('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Refresh user profile
  Future<void> refreshUserProfile({
    required String userId,
    required String token,
  }) async {
    try {
      print('🔄 Refreshing user profile...');
      await fetchUserProfile(userId: userId, token: token);
      print('✅ Profile refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing profile: $e');
      setError('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required String token,
    String? nik,
    String? nama,
    String? noHp,
    String? tempatLahir,
    String? tanggalLahir,
    String? provinsi,
    String? kota,
    String? kecamatan,
    String? alamat,
    dynamic fotoDiri,
    dynamic fotoKtp,
    dynamic fotoProfile,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final result = await _userService.updateUser(
        userId: userId,
        token: token,
        nik: nik,
        nama: nama,
        noHp: noHp,
        tempatLahir: tempatLahir,
        tanggalLahir: tanggalLahir,
        provinsi: provinsi,
        kota: kota,
        kecamatan: kecamatan,
        alamat: alamat,
        fotoDiri: fotoDiri,
        fotoKtp: fotoKtp,
        fotoProfile: fotoProfile,
      );

      setLoading(false);

      if (result['success'] == true) {
        // Refresh profile after update
        await fetchUserProfile(userId: userId, token: token);
        return {'success': true, 'message': result['message']};
      } else {
        setError(result['message']);
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // PAY MEMBER
  Future<Map<String, dynamic>> payMember({
    required String token,
    required PaymentModel paymentModel,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final result = await AuthService.payMember(
        token: token,
        payment: paymentModel,
      );

      setLoading(false);

      if (result['success'] == true) {
        return {'success': true, 'message': result['message']};
      } else {
        setError(result['message']);
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String token,
    required String otp,
  }) async {
    setLoading(true);
    setError(null);

    try {
      print('=== VERIFY OTP ===');
      final result = await _userService.verifyOtp(
        token: token,
        otp: otp,
      );

      setLoading(false);

      if (result['success'] == true) {
        notifyListeners();
        return {'success': true, 'message': result['message']};
      } else {
        setError(result['message']);
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      print('=== VERIFY OTP ERROR ===');
      print('Exception: $e');
      print('========================');
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // Clear user data (saat logout)
  void clearUserData() {
    _userName = null;
    _userProfile = null;
    _errorMessage = null;
    notifyListeners();
  }
}