import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/config/api_endpoint/api_endpoints.dart';
import 'package:koperasi_rsb/models/user_model.dart';
import 'package:koperasi_rsb/models/payment-member_model.dart';
import 'package:koperasi_rsb/utils/shared_preferences_helper.dart';
import 'package:koperasi_rsb/services/user_services.dart';

// Helper function untuk decode JWT token
Map<String, dynamic>? _decodeJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      print('❌ JWT token tidak valid: harus 3 bagian');
      return null;
    }

    String payload = parts[1];
    payload = payload.replaceAll('-', '+').replaceAll('_', '/');
    
    switch (payload.length % 4) {
      case 0:
        break;
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
      default:
        print('❌ Base64 string tidak valid');
        return null;
    }
    
    final decoded = utf8.decode(base64.decode(payload));
    print('🔍 JWT Payload (decoded): $decoded');
    final Map<String, dynamic> result = jsonDecode(decoded);
    
    return result;
  } catch (e) {
    print('❌ Error decoding JWT: $e');
    return null;
  }
}

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _errorMessage;
  String? _userStatus;
  String? _userName; // ⭐ TAMBAHAN
  String? _userRole;  // ⭐ TAMBAHAN
  String? _userId;    // ⭐ TAMBAHAN
  Map<String, dynamic> _registrationData = {};
  bool _isLoading = false;
  bool _rememberMe = false;
  
  final UserService _userService = UserService(); // ⭐ TAMBAHAN

  String? get token => _token;
  String? get errorMessage => _errorMessage;
  String? get userStatus => _userStatus;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  Map<String, dynamic> get registrationData => _registrationData;

  // ⭐ TAMBAHAN: Initialize dan load saved data saat app start
  Future<void> initialize() async {
    await loadSavedData();
  }

  // ⭐ TAMBAHAN: Fetch user profile menggunakan UserService
  Future<void> fetchUserProfile() async {
    if (_token == null || _userId == null) {
      print('⚠️ Cannot fetch profile: token or userId is null');
      return;
    }

    try {
      print('🔄 Fetching user profile for ID: $_userId');
      
      final result = await _userService.getUserById(
        userId: _userId!,
        token: _token!,
      );

      if (result['success'] == true && result['data'] != null) {
        final userData = result['data'];
        _userName = userData['nama'];
        
        // Save nama ke SharedPreferences untuk persistence
        if (_userName != null) {
          await SharedPreferencesHelper.saveUserName(_userName!);
        }
        
        print('✅ User profile fetched successfully');
        print('   Name: $_userName');
        notifyListeners();
      } else {
        print('⚠️ Failed to fetch profile: ${result['message']}');
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
    }
  }

  // ⭐ TAMBAHAN: Load saved data dari SharedPreferences
  Future<void> loadSavedData() async {
    try {
      // Load token
      _token = await SharedPreferencesHelper.getToken();
      
      // Load user status
      _userStatus = await SharedPreferencesHelper.getUserStatus();
      
      // Load user name
      _userName = await SharedPreferencesHelper.getUserName();
      
      // Load credentials
      final credentials = await SharedPreferencesHelper.getSavedCredentials();
      _rememberMe = credentials['remember_me'] ?? false;
      
      // ⭐ Decode token untuk ambil userId dan role
      if (_token != null) {
        final decodedToken = _decodeJwt(_token!);
        if (decodedToken != null) {
          _userId = decodedToken['id'] as String?;
          _userRole = decodedToken['role'] as String?;
          
          // Jika nama null tapi ada token & userId, fetch dari API
          if (_userName == null && _userId != null) {
            print('⚠️ Nama not found in cache, fetching from API...');
            await fetchUserProfile();
          }
        }
      }
      
      print('=== 📂 LOADED SAVED DATA ===');
      print('Token exists: ${_token != null}');
      print('User ID: $_userId');
      print('User Status: $_userStatus');
      print('User Name: $_userName');
      print('User Role: $_userRole');
      print('Remember Me: $_rememberMe');
      print('============================');
      
      notifyListeners();
    } catch (e) {
      print('❌ Error loading saved data: $e');
    }
  }

  // ⭐ TAMBAHAN: Get saved credentials untuk auto-fill
  Future<Map<String, String?>> getSavedCredentials() async {
    final credentials = await SharedPreferencesHelper.getSavedCredentials();
    return {
      'no_hp': credentials['no_hp'],
      'password': credentials['password'],
      'remember_me': credentials['remember_me'].toString(),
    };
  }

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

  // ⭐ UPDATED: Login method dengan fetch user profile
  Future<bool> login(String noHp, String password, {bool rememberMe = false}) async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.post(
        Uri.parse(AuthEndpoints.login),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'no_hp': noHp,
          'password': password,
        }),
      );

      print('=== LOGIN RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('============================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        
        // ⭐ Save token to SharedPreferences
        if (_token != null) {
          await SharedPreferencesHelper.saveToken(_token!);
        }
        
        print('\n🔑 Token received: ${_token?.substring(0, 30)}...\n');
        
        // Decode JWT untuk mendapatkan userId, status, dan role
        if (_token != null) {
          print('🔓 Attempting to decode JWT...');
          final decodedToken = _decodeJwt(_token!);
          
          if (decodedToken != null) {
            _userId = decodedToken['id'] as String?;
            _userStatus = decodedToken['status'] as String?;
            _userRole = decodedToken['role'] as String?;
            
            // ⭐ Save user status to SharedPreferences
            if (_userStatus != null) {
              await SharedPreferencesHelper.saveUserStatus(_userStatus!);
            }
            
            print('\n=== ✅ JWT DECODED SUCCESSFULLY ===');
            print('User ID: $_userId');
            print('Role: $_userRole');
            print('Status: $_userStatus');
            print('IAT: ${decodedToken['iat']}');
            print('EXP: ${decodedToken['exp']}');
            print('===================================\n');
            
            // ⭐ Fetch nama dari API menggunakan userId
            if (_userId != null) {
              print('🔄 Fetching user name from API...');
              await fetchUserProfile();
            }
          } else {
            print('⚠️ Failed to decode JWT token');
          }
        } else {
          print('⚠️ Token is null');
        }
        
        // ⭐ Save credentials jika remember me aktif
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
        print('User Name: $_userName');
        print('User Role: $_userRole');
        print('User Status: $_userStatus');
        print('Remember Me: $rememberMe');
        print('========================\n');
        
        notifyListeners();
        return true;
      } else {
        setLoading(false);
        final error = jsonDecode(response.body);
        setError(error['message'] ?? 'Login gagal');
        return false;
      }
    } catch (e) {
      print('\n=== ❌ LOGIN ERROR ===');
      print('Exception: $e');
      print('Stack trace: ${StackTrace.current}');
      print('======================\n');
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      return false;
    }
  }

  // Step 1: Register user
  Future<Map<String, dynamic>> registerUser() async {
    setLoading(true);
    setError(null);

    try {
      print('\n=== DEBUG REGISTRATION DATA ===');
      print('Raw _registrationData keys: ${_registrationData.keys.toList()}');
      print('================================\n');

      final userModel = UserModel.fromRegistrationData(_registrationData);

      print('\n=== DEBUG USER MODEL ===');
      print('nama: ${userModel.nama}');
      print('no_hp: ${userModel.noHp}');
      print('password: ${userModel.password.isNotEmpty ? "***" : "EMPTY"}');
      print('isValid: ${userModel.isValid()}');
      print('========================\n');

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

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AuthEndpoints.register),
      );

      request.fields['nama'] = userModel.nama.trim();
      request.fields['no_hp'] = userModel.noHp.trim();
      request.fields['password'] = userModel.password.trim();
      request.fields['tempat_lahir'] = (userModel.tempatLahir ?? '').trim();
      request.fields['tanggal_lahir'] = (userModel.tanggalLahir ?? '').trim();
      request.fields['provinsi'] = (userModel.provinsi ?? '').trim();
      request.fields['kota'] = (userModel.kota ?? '').trim();
      request.fields['kecamatan'] = (userModel.kecamatan ?? '').trim();
      request.fields['alamat'] = (userModel.alamat ?? '').trim();
      request.fields['nik'] = (userModel.nik ?? '').trim();
      request.fields['role'] = userModel.role;
      
      var fotoDiriMultipart = await http.MultipartFile.fromPath(
        'foto_diri',
        fotoDiriFile.path,
      );
      request.files.add(fotoDiriMultipart);

      var fotoKtpMultipart = await http.MultipartFile.fromPath(
        'foto_ktp',
        fotoKtpFile.path,
      );
      request.files.add(fotoKtpMultipart);

      print('=== REGISTER USER DEBUG ===');
      print('URL: ${AuthEndpoints.register}');
      print('Files: foto_diri, foto_ktp');
      print('===========================');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      setLoading(false);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        String errorMessage = 'Registrasi gagal';
        
        if (error['error'] != null) {
          if (error['error']['details'] != null) {
            final details = error['error']['details'] as List;
            errorMessage = details.map((d) => d['message']).join(', ');
          } else if (error['error'] is String) {
            errorMessage = error['error'];
          }
        } else if (error['message'] != null) {
          errorMessage = error['message'];
        }
        
        setError(errorMessage);
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception: $e');
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // ⭐ UPDATED: Login for token dengan fetch profile
  Future<bool> loginForToken() async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.post(
        Uri.parse(AuthEndpoints.login),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'no_hp': _registrationData['no_hp'],
          'password': _registrationData['password'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        
        if (_token != null) {
          await SharedPreferencesHelper.saveToken(_token!);
          
          final decodedToken = _decodeJwt(_token!);
          if (decodedToken != null) {
            _userId = decodedToken['id'] as String?;
            _userStatus = decodedToken['status'] as String?;
            _userRole = decodedToken['role'] as String?;
            
            if (_userStatus != null) {
              await SharedPreferencesHelper.saveUserStatus(_userStatus!);
            }
            
            // ⭐ Fetch user profile
            if (_userId != null) {
              await fetchUserProfile();
            }
            
            print('=== ✅ LOGIN FOR TOKEN SUCCESS ===');
            print('Token: ${_token?.substring(0, 20)}...');
            print('User ID: $_userId');
            print('User Name: $_userName');
            print('User Role: $_userRole');
            print('User Status: $_userStatus');
            print('==================================');
          }
        }
        
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

  // Combined Register + Payment
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
      final paymentResult = await payMember(paymentModel);

      return paymentResult;
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      return {'success': false, 'message': _errorMessage};
    }
  }

  // Pay member
  Future<Map<String, dynamic>> payMember(PaymentModel paymentModel) async {
    if (_token == null) {
      return {'success': false, 'message': 'Token tidak ditemukan'};
    }

    if (!paymentModel.isValid()) {
      return {'success': false, 'message': 'Data pembayaran tidak lengkap'};
    }

    setLoading(true);
    setError(null);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(PaymentEndpoints.payMember),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $_token',
      });

      request.fields['nama_bank'] = paymentModel.namaBank.trim();
      request.fields['no_rekening'] = paymentModel.noRekening.trim();
      request.fields['nama_pemilik_rekening'] = paymentModel.namaPemilikRekening.trim();

      request.files.add(
        await http.MultipartFile.fromPath(
          'bukti_pembayaran',
          paymentModel.buktiPembayaran.path,
        ),
      );

      print('=== PAY MEMBER DEBUG ===');
      print('URL: ${PaymentEndpoints.payMember}');
      print('Fields: ${request.fields}');
      print('File: bukti_pembayaran');
      print('========================');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      setLoading(false);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        setError(error['message'] ?? 'Pembayaran gagal');
        return {'success': false, 'message': _errorMessage};
      }
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      setLoading(false);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // ⭐ UPDATED: Verify OTP dengan update status
  Future<Map<String, dynamic>> verifyOtp(String noHp, String password, String otp) async {
    setLoading(true);
    setError(null);

    try {
      print('=== STEP 1: LOGIN FOR OTP VERIFICATION ===');
      final loginSuccess = await login(noHp, password);
      
      if (!loginSuccess || _token == null) {
        setLoading(false);
        return {'success': false, 'message': 'Gagal login. Silakan periksa nomor HP dan password Anda.'};
      }

      print('=== STEP 2: VERIFY OTP ===');
      print('URL: ${UserEndpoints.verifyOtp}');
      print('Token: ${_token?.substring(0, 20)}...');
      print('OTP: $otp');
      print('==========================');

      final response = await http.post(
        Uri.parse(UserEndpoints.verifyOtp),
        headers: ApiConfig.getAuthHeaders(_token!),
        body: jsonEncode({'otp': otp}),
      );

      print('=== VERIFY OTP RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('===========================');

      setLoading(false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Update user status to AKTIF
        _userStatus = 'AKTIF';
        
        // ⭐ Save updated status to SharedPreferences
        await SharedPreferencesHelper.saveUserStatus('AKTIF');
        
        // Clear registration data
        clearRegistrationData();
        
        notifyListeners();
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        setError(error['message'] ?? 'Verifikasi OTP gagal');
        return {'success': false, 'message': _errorMessage};
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
  Future<void> refreshUserProfile() async {
  if (_token == null || _userId == null) {
    print('⚠️ Cannot refresh profile: token or userId is null');
    return;
  }

  try {
    print('🔄 Refreshing user profile...');
    await fetchUserProfile();
    print('✅ Profile refreshed successfully');
  } catch (e) {
    print('❌ Error refreshing profile: $e');
  }
}

  // ⭐ UPDATED: Logout dengan opsi keep credentials
  Future<bool> logout({bool keepCredentials = false}) async {
    setLoading(true);
    setError(null);

    try {
      final Map<String, String> headers = {};
      
      if (_token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final response = await http.post(
        Uri.parse(AuthEndpoints.logout),
        headers: headers,
      );

      setLoading(false);

      _token = null;
      _userStatus = null;
      _userName = null;
      _userRole = null;
      _userId = null;
      _registrationData = {};
      _errorMessage = null;
      
      // ⭐ Clear data from SharedPreferences
      if (keepCredentials && _rememberMe) {
        // Keep credentials but clear token and status
        await SharedPreferencesHelper.clearAllExceptCredentials();
        print('🔓 Logout: Credentials kept');
      } else {
        // Clear everything including credentials
        await SharedPreferencesHelper.clearAll();
        _rememberMe = false;
        print('🗑️ Logout: All data cleared');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _token = null;
      _userStatus = null;
      _userName = null;
      _userRole = null;
      _userId = null;
      _registrationData = {};
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      
      if (keepCredentials && _rememberMe) {
        await SharedPreferencesHelper.clearAllExceptCredentials();
      } else {
        await SharedPreferencesHelper.clearAll();
        _rememberMe = false;
      }
      
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}