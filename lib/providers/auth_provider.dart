import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/config/api_endpoint/api_endpoints.dart';
import 'package:koperasi_rsb/models/user_model.dart';
import 'package:koperasi_rsb/models/payment-member_model.dart';

// ⭐ Helper function untuk decode JWT token - FIXED VERSION
Map<String, dynamic>? _decodeJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      print('❌ JWT token tidak valid: harus 3 bagian');
      return null;
    }

    // Decode payload (bagian ke-2 dari JWT)
    String payload = parts[1];
    
    // Normalize base64 string
    // JWT menggunakan base64url encoding, perlu di-normalize
    payload = payload.replaceAll('-', '+').replaceAll('_', '/');
    
    // Tambahkan padding jika diperlukan
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
    
    // Decode base64
    final decoded = utf8.decode(base64.decode(payload));
    
    print('🔍 JWT Payload (decoded): $decoded');
    
    // Parse JSON
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
  String? _userStatus; // ⭐ TAMBAHAN: User status
  Map<String, dynamic> _registrationData = {};
  bool _isLoading = false;

  String? get token => _token;
  String? get errorMessage => _errorMessage;
  String? get userStatus => _userStatus; // ⭐ TAMBAHAN: Getter untuk user status
  bool get isLoading => _isLoading;
  Map<String, dynamic> get registrationData => _registrationData;

  // Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Set token manually
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  // ⭐ TAMBAHAN: Set user status
  void setUserStatus(String? status) {
    _userStatus = status;
    notifyListeners();
  }

  // Save registration step data
  void saveRegistrationStep(Map<String, dynamic> data) {
    _registrationData.addAll(data);
    notifyListeners();
  }

  // Clear registration data
  void clearRegistrationData() {
    _registrationData = {};
    notifyListeners();
  }

  // Login method - ⭐ UPDATED: Decode JWT untuk ambil status (FIXED)
  Future<bool> login(String noHp, String password) async {
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
        
        print('\n🔑 Token received: ${_token?.substring(0, 30)}...\n');
        
        // ⭐ DECODE JWT untuk mendapatkan status
        if (_token != null) {
          print('🔓 Attempting to decode JWT...');
          final decodedToken = _decodeJwt(_token!);
          
          if (decodedToken != null) {
            // Ambil status dari JWT payload
            _userStatus = decodedToken['status'] as String?;
            
            print('\n=== ✅ JWT DECODED SUCCESSFULLY ===');
            print('User ID: ${decodedToken['id']}');
            print('Role: ${decodedToken['role']}');
            print('Status: $_userStatus');
            print('IAT: ${decodedToken['iat']}');
            print('EXP: ${decodedToken['exp']}');
            print('===================================\n');
          } else {
            print('⚠️ Failed to decode JWT token');
          }
        } else {
          print('⚠️ Token is null');
        }
        
        setLoading(false);
        
        print('=== 🎉 LOGIN SUCCESS ===');
        print('Token: ${_token?.substring(0, 20)}...');
        print('User Status: $_userStatus');
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

  // Step 1: Register user using multipart/form-data
  Future<Map<String, dynamic>> registerUser() async {
    setLoading(true);
    setError(null);

    try {
      print('\n=== DEBUG REGISTRATION DATA ===');
      print('Raw _registrationData keys: ${_registrationData.keys.toList()}');
      print('================================\n');

      // Create UserModel from registration data
      final userModel = UserModel.fromRegistrationData(_registrationData);

      print('\n=== DEBUG USER MODEL ===');
      print('nama: ${userModel.nama}');
      print('no_hp: ${userModel.noHp}');
      print('password: ${userModel.password.isNotEmpty ? "***" : "EMPTY"}');
      print('isValid: ${userModel.isValid()}');
      print('========================\n');

      // Validate model
      if (!userModel.isValid()) {
        setLoading(false);
        setError('Data registrasi tidak lengkap');
        return {'success': false, 'message': 'Data registrasi tidak lengkap'};
      }

      // Get both files from registration data
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

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AuthEndpoints.register),
      );

      // Add text fields
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
      
      // Add foto_diri file
      var fotoDiriMultipart = await http.MultipartFile.fromPath(
        'foto_diri',
        fotoDiriFile.path,
      );
      request.files.add(fotoDiriMultipart);

      // Add foto_ktp file
      var fotoKtpMultipart = await http.MultipartFile.fromPath(
        'foto_ktp',
        fotoKtpFile.path,
      );
      request.files.add(fotoKtpMultipart);

      print('=== REGISTER USER DEBUG ===');
      print('URL: ${AuthEndpoints.register}');
      print('Files: foto_diri, foto_ktp');
      print('===========================');

      // Send request
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

  // Step 2: Login to get token - ⭐ UPDATED: Decode JWT untuk ambil status (FIXED)
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
        
        // ⭐ DECODE JWT untuk mendapatkan status
        if (_token != null) {
          final decodedToken = _decodeJwt(_token!);
          if (decodedToken != null) {
            _userStatus = decodedToken['status'] as String?;
            
            print('=== ✅ LOGIN FOR TOKEN SUCCESS ===');
            print('Token: ${_token?.substring(0, 20)}...');
            print('User Status: $_userStatus');
            print('Role: ${decodedToken['role']}');
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

  // ⭐ NEW: Combined Register + Payment Method
  Future<Map<String, dynamic>> registerAndPay(PaymentModel paymentModel) async {
    try {
      // Step 1: Register user
      print('=== STEP 1: REGISTERING USER ===');
      final registerResult = await registerUser();

      if (!registerResult['success']) {
        return registerResult;
      }

      // Step 2: Login untuk mendapatkan token
      print('=== STEP 2: LOGIN FOR TOKEN ===');
      final loginSuccess = await loginForToken();

      if (!loginSuccess) {
        return {
          'success': false,
          'message': 'Registrasi berhasil, tetapi gagal login otomatis. Silakan login manual.'
        };
      }

      // Step 3: Submit payment
      print('=== STEP 3: SUBMITTING PAYMENT ===');
      final paymentResult = await payMember(paymentModel);

      return paymentResult;
    } catch (e) {
      setError('Terjadi kesalahan: ${e.toString()}');
      return {'success': false, 'message': _errorMessage};
    }
  }

  // Step 3: Pay member with multipart (Updated to use PaymentModel)
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

      // Add payment fields according to backend validation
      request.fields['nama_bank'] = paymentModel.namaBank.trim();
      request.fields['no_rekening'] = paymentModel.noRekening.trim();
      request.fields['nama_pemilik_rekening'] = paymentModel.namaPemilikRekening.trim();

      // Add bukti_pembayaran file
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

  // Step 4: Verify OTP - ⭐ UPDATED: Pastikan token terkirim dengan benar
  Future<Map<String, dynamic>> verifyOtp(String noHp, String password, String otp) async {
    setLoading(true);
    setError(null);

    try {
      // ⭐ PENTING: Login dulu untuk mendapatkan token terbaru
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
        
        // Update user status to AKTIF after successful OTP verification
        _userStatus = 'AKTIF';
        
        // Clear registration data after successful verification
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

  // Logout method - ⭐ UPDATED: Clear user status juga
  Future<bool> logout() async {
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
      _userStatus = null; // ⭐ Clear user status
      _registrationData = {};
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _token = null;
      _userStatus = null; // ⭐ Clear user status
      _registrationData = {};
      setError('Terjadi kesalahan: $e');
      setLoading(false);
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}