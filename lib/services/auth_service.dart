import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';
import './api_service.dart';
import '../utils/shared_preferences_helper.dart';
import '../config/api_endpoint/api_endpoints.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login(String noHp, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AuthEndpoints.login),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'no_hp': noHp,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String status = data['user']['status'] ?? '';
        final String token = data['token'] ?? '';

        return {
          'success': true,
          'message': 'Login berhasil',
          'status': status,
          'token': token,
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(
    UserModel user, {
    File? fotoKtp,
    File? fotoDiri,
  }) async {
    try {
      Map<String, String> fields = {
        'nama': user.nama,
        'no_hp': user.noHp,
        'password': user.password,
        if (user.tempatLahir != null) 'tempat_lahir': user.tempatLahir!,
        if (user.tanggalLahir != null) 'tanggal_lahir': user.tanggalLahir!,
        if (user.provinsi != null) 'provinsi': user.provinsi!,
        if (user.kota != null) 'kota': user.kota!,
        if (user.kecamatan != null) 'kecamatan': user.kecamatan!,
        if (user.alamat != null) 'detail_alamat': user.alamat!,
        if (user.nik != null) 'nik': user.nik!,
      };

      Map<String, File>? files;
      if (fotoKtp != null || fotoDiri != null) {
        files = {};
        if (fotoKtp != null) files['foto_ktp'] = fotoKtp;
        if (fotoDiri != null) files['foto_diri'] = fotoDiri;
      }

      final response = await ApiService.postMultipart(
        AuthEndpoints.register,
        fields,
        files: files,
      );

      if (response['success']) {
        return {
          'success': true,
          'message': response['data']['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan',
        };
      }

      final response = await ApiService.post(
        AuthEndpoints.logout,
        {},
        headers: ApiConfig.getAuthHeaders(token),
      );

      // Hapus token dari local storage
      await SharedPreferencesHelper.removeToken();

      if (response['success']) {
        return {
          'success': true,
          'message': 'Logout berhasil',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Logout gagal',
        };
      }
    } catch (e) {
      // Tetap hapus token meskipun request gagal
      await SharedPreferencesHelper.removeToken();
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await SharedPreferencesHelper.getToken();
    return token != null;
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String token, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(UserEndpoints.verifyOtp),
        headers: ApiConfig.getAuthHeaders(token),
        body: jsonEncode({'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP berhasil diverifikasi',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Verifikasi OTP gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }
}