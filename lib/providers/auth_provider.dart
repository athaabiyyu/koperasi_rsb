import 'dart:io';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/models/user_model.dart';
import 'package:koperasi_rsb/models/payment-member_model.dart';
import 'package:koperasi_rsb/utils/shared_preferences_helper.dart';
import 'package:koperasi_rsb/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _errorMessage;
  String? _userStatus;
  String? _userRole;
  String? _userId;
  Map<String, dynamic> _registrationData = {};
  bool _isLoading = false;
  bool _rememberMe = false;

  // Getters
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  String? get userStatus => _userStatus;
  String? get userRole => _userRole;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  Map<String, dynamic> get registrationData => _registrationData;

  // Initialize dan load saved data saat app start
  Future<void> initialize() async {
    await loadSavedData();
  }

  // Load saved data dari SharedPreferences
  Future<void> loadSavedData() async {
    try {
      _token = await SharedPreferencesHelper.getToken();
      _userStatus = await SharedPreferencesHelper.getUserStatus();
      
      final credentials = await SharedPreferencesHelper.getSavedCredentials();
      _rememberMe = credentials['remember_me'] ?? false;
      
      if (_token != null) {
        final decodedToken = AuthService.decodeJwt(_token!);
        if (decodedToken != null) {
          _userId = decodedToken['id'] as String?;
          _userRole = decodedToken['role'] as String?;
        }
      }
      
      print('=== 📂 LOADED SAVED DATA ===');
      print('Token exists: ${_token != null}');
      print('User ID: $_userId');
      print('User Status: $_userStatus');
      print('User Role: $_userRole');
      print('Remember Me: $_rememberMe');
      print('============================');
      
      notifyListeners();
    } catch (e) {
      print('❌ Error loading saved data: $e');
    }
  }

  // Get saved credentials untuk auto-fill
  Future<Map<String, String?>> getSavedCredentials() async {
    final credentials = await SharedPreferencesHelper.getSavedCredentials();
    return {
      'no_hp': credentials['no_hp'],
      'password': credentials['password'],
      'remember_me': credentials['remember_me'].toString(),
    };
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

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setUserStatus(String? status) {
    _userStatus = status;
    notifyListeners();
  }

  void saveRegistrationStep(Map<String, dynamic> data) {
    _registrationData.addAll(data);
    notifyListeners();
  }

  void clearRegistrationData() {
    _registrationData = {};
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // LOGIN
  Future<bool> login(String noHp, String password, {bool rememberMe = false}) async {
    setLoading(true);
    setError(null);

    try {
      final result = await AuthService.login(noHp, password);

      if (result['success'] == true) {
        _token = result['token'];
        _userId = result['userId'];
        _userStatus = result['userStatus'];
        _userRole = result['userRole'];
        
        // Save to SharedPreferences
        if (_token != null) {
          await SharedPreferencesHelper.saveToken(_token!);
        }
        if (_userStatus != null) {
          await SharedPreferencesHelper.saveUserStatus(_userStatus!);
        }
        
        // Save credentials jika remember me aktif
        _rememberMe = rememberMe;
        await SharedPreferencesHelper.saveCredentials(
          noHp: noHp,
          password: password,
          rememberMe: rememberMe,
        );
        
        setLoading(false);
        
        print('=== 🎉 LOGIN SUCCESS ===');
        print('Token: ${_token?.substring(0, 20)}...');
        print('User ID: $_userId');
        print('User Role: $_userRole');
        print('User Status: $_userStatus');
        print('Remember Me: $rememberMe');
        print('========================\n');
        
        notifyListeners();
        return true;
      } else {
        setLoading(false);
        setError(result['message'] ?? 'Login gagal');
        return false;
      }
    } catch (e) {
      print('\n=== ❌ LOGIN ERROR ===');
      print('Exception: $e');
      print('======================\n');
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      return false;
    }
  }

  // REGISTER USER
  Future<Map<String, dynamic>> registerUser() async {
    setLoading(true);
    setError(null);

    try {
      print('\n=== DEBUG REGISTRATION DATA ===');
      print('Raw _registrationData keys: ${_registrationData.keys.toList()}');
      print('================================\n');

      final userModel = UserModel.fromRegistrationData(_registrationData);

      if (!userModel.isValid()) {
        setLoading(false);
        setError('Data registrasi tidak lengkap');
        return {'success': false, 'message': 'Data registrasi tidak lengkap'};
      }

      File? fotoDiriFile = _registrationData['foto_diri_file'] as File?;
      File? fotoKtpFile = _registrationData['foto_ktp_file'] as File?;
      
      if (fotoDiriFile == null) {
        setError('File foto diri tidak ditemukan');
        setLoading(false);
        return {'success': false, 'message': 'File foto diri tidak ditemukan'};
      }
      
      if (fotoKtpFile == null) {
        setError('File KTP tidak ditemukan');
        setLoading(false);
        return {'success': false, 'message': 'File KTP tidak ditemukan'};
      }

      final result = await AuthService.registerUser(
        user: userModel,
        fotoDiri: fotoDiriFile,
        fotoKtp: fotoKtpFile,
      );

      setLoading(false);

      if (result['success'] == true) {
        return {'success': true, 'message': result['message']};
      } else {
        setError(result['message']);
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      print('Exception: $e');
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // LOGIN FOR TOKEN (after registration)
  Future<bool> loginForToken() async {
    setLoading(true);
    setError(null);

    try {
      final result = await AuthService.login(
        _registrationData['no_hp'],
        _registrationData['password'],
      );

      if (result['success'] == true) {
        _token = result['token'];
        _userId = result['userId'];
        _userStatus = result['userStatus'];
        _userRole = result['userRole'];
        
        if (_token != null) {
          await SharedPreferencesHelper.saveToken(_token!);
        }
        if (_userStatus != null) {
          await SharedPreferencesHelper.saveUserStatus(_userStatus!);
        }
        
        print('=== ✅ LOGIN FOR TOKEN SUCCESS ===');
        print('Token: ${_token?.substring(0, 20)}...');
        print('User ID: $_userId');
        print('User Role: $_userRole');
        print('User Status: $_userStatus');
        print('==================================');
        
        setLoading(false);
        notifyListeners();
        return true;
      } else {
        setLoading(false);
        setError('Login untuk token gagal');
        return false;
      }
    } catch (e) {
      setError('Login gagal: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // REGISTER AND PAY (Combined flow)
  Future<Map<String, dynamic>> registerAndPay(PaymentModel paymentModel) async {
    try {
      print('=== STEP 1: REGISTERING USER ===');
      final registerResult = await registerUser();

      if (!registerResult['success']) {
        return registerResult;
      }

      print('=== STEP 2: LOGIN FOR TOKEN ===');
      final loginSuccess = await loginForToken();

      if (!loginSuccess) {
        return {
          'success': false,
          'message': 'Registrasi berhasil, tetapi gagal login otomatis. Silakan login manual.'
        };
      }

      print('=== STEP 3: SUBMITTING PAYMENT ===');
      if (_token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      setLoading(true);
      final result = await AuthService.payMember(
        token: _token!,
        payment: paymentModel,
      );
      setLoading(false);

      return result;
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // LOGOUT
  Future<bool> logout({bool keepCredentials = false, BuildContext? context}) async {
  setLoading(true);
  setError(null);

  try {
    final result = await AuthService.logout(token: _token);

    setLoading(false);

    // Clear state
    _token = null;
    _userStatus = null;
    _userRole = null;
    _userId = null;
    _registrationData = {};
    _errorMessage = null;
    
    // Clear topup data from TopupProvider if context is provided
    if (context != null) {
      try {
        final topupProvider = Provider.of<TopupProvider>(context, listen: false);
        topupProvider.clearTopupData();
        print('🗑️ Topup data cleared');
      } catch (e) {
        print('⚠️ Could not clear topup data: $e');
      }
    }
    
    // Clear data from SharedPreferences
    if (keepCredentials && _rememberMe) {
      await SharedPreferencesHelper.clearAllExceptCredentials();
      print('🔓 Logout: Credentials kept');
    } else {
      await SharedPreferencesHelper.clearAll();
      _rememberMe = false;
      print('🗑️ Logout: All data cleared');
    }
    
    notifyListeners();
    return result['success'] == true;
  } catch (e) {
    // Clear state even on error
    _token = null;
    _userStatus = null;
    _userRole = null;
    _userId = null;
    _registrationData = {};
    
    // Clear topup data
    if (context != null) {
      try {
        final topupProvider = Provider.of<TopupProvider>(context, listen: false);
        topupProvider.clearTopupData();
      } catch (e) {
        print('⚠️ Could not clear topup data: $e');
      }
    }
    
    setError('Terjadi kesalahan: $e');
    setLoading(false);
    
    if (keepCredentials && _rememberMe) {
      await SharedPreferencesHelper.clearAllExceptCredentials();
    } else {
      await SharedPreferencesHelper.clearAll();
      _rememberMe = false;
    }
    
    notifyListeners();
    return false;
  }
}
}