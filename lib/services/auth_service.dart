import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/api_endpoint/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/payment-member_model.dart';
import '../utils/shared_preferences_helper.dart';
import '../config/api_endpoint/api_endpoints.dart';


class AuthService {
  // Helper function untuk decode JWT token
    static Map<String, dynamic>? decodeJwt(String token) {
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

      print('=== LOGIN RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('============================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'] ?? '';
        
        // Decode JWT untuk mendapatkan userId, status, dan role
        Map<String, dynamic>? decodedToken;
        String? userId;
        String? userStatus;
        String? userRole;
        
        if (token.isNotEmpty) {
          decodedToken = decodeJwt(token);
          
          if (decodedToken != null) {
            userId = decodedToken['id'] as String?;
            userStatus = decodedToken['status'] as String?;
            userRole = decodedToken['role'] as String?;
            
            print('\n=== ✅ JWT DECODED SUCCESSFULLY ===');
            print('User ID: $userId');
            print('Role: $userRole');
            print('Status: $userStatus');
            print('===================================\n');
          }
        }

        return {
          'success': true,
          'message': 'Login berhasil',
          'token': token,
          'userId': userId,
          'userStatus': userStatus,
          'userRole': userRole,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('\n=== ❌ LOGIN ERROR ===');
      print('Exception: $e');
      print('======================\n');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Register User
  static Future<Map<String, dynamic>> registerUser({
    required UserModel user,
    required File fotoDiri,
    required File fotoKtp,
  }) async {
    try {
      print('\n=== DEBUG USER MODEL ===');
      print('nama: ${user.nama}');
      print('no_hp: ${user.noHp}');
      print('password: ${user.password.isNotEmpty ? "***" : "EMPTY"}');
      print('isValid: ${user.isValid()}');
      print('========================\n');

      if (!user.isValid()) {
        return {'success': false, 'message': 'Data registrasi tidak lengkap'};
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AuthEndpoints.register),
      );

      request.fields['nama'] = user.nama.trim();
      request.fields['no_hp'] = user.noHp.trim();
      request.fields['password'] = user.password.trim();
      request.fields['tempat_lahir'] = (user.tempatLahir ?? '').trim();
      request.fields['tanggal_lahir'] = (user.tanggalLahir ?? '').trim();
      request.fields['provinsi'] = (user.provinsi ?? '').trim();
      request.fields['kota'] = (user.kota ?? '').trim();
      request.fields['kecamatan'] = (user.kecamatan ?? '').trim();
      request.fields['alamat'] = (user.alamat ?? '').trim();
      request.fields['nik'] = (user.nik ?? '').trim();
      request.fields['role'] = user.role;
      
      var fotoDiriMultipart = await http.MultipartFile.fromPath(
        'foto_diri',
        fotoDiri.path,
      );
      request.files.add(fotoDiriMultipart);

      var fotoKtpMultipart = await http.MultipartFile.fromPath(
        'foto_ktp',
        fotoKtp.path,
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
        
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  // Pay Member
  static Future<Map<String, dynamic>> payMember({
    required String token,
    required PaymentModel payment,
  }) async {
    if (!payment.isValid()) {
      return {'success': false, 'message': 'Data pembayaran tidak lengkap'};
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(PaymentEndpoints.payMember),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['nama_bank'] = payment.namaBank.trim();
      request.fields['no_rekening'] = payment.noRekening.trim();
      request.fields['nama_pemilik_rekening'] = payment.namaPemilikRekening.trim();

      request.files.add(
        await http.MultipartFile.fromPath(
          'bukti_pembayaran',
          payment.buktiPembayaran.path,
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

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Pembayaran gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  // Logout
  static Future<Map<String, dynamic>> logout({String? token}) async {
    try {
      final Map<String, String> headers = {};
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse(AuthEndpoints.logout),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Logout berhasil',
        };
      } else {
        return {
          'success': false,
          'message': 'Logout gagal',
        };
      }
    } catch (e) {
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
}