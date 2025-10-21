import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../config/api_config.dart';
import '../config/api_endpoint/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/payment-member_model.dart';
import '../utils/shared_preferences_helper.dart';

class AuthService {
  // Helper function untuk decode JWT token
  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
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
          return null;
      }
      
      final decoded = utf8.decode(base64.decode(payload));
      final Map<String, dynamic> result = jsonDecode(decoded);
      
      return result;
    } catch (e) {
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
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
        Uri.parse(TopupEndpoints.payMember),
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

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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

  // Upgrade to Platinum - CORRECTED VERSION
  static Future<Map<String, dynamic>> upgradeToPlatinum({
  required String token,
  required PaymentModel payment,
  required int nominal,
}) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(UserEndpoints.upgradePlatinum),
    );

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Add fields
    request.fields['nama_bank'] = payment.namaBank;
    request.fields['no_rekening'] = payment.noRekening;
    request.fields['nama_pemilik_rekening'] = payment.namaPemilikRekening;
    request.fields['nominal'] = nominal.toString();

    // Add file
    final stream = payment.buktiPembayaran.openRead();
    final length = await payment.buktiPembayaran.length();

    final multipartFile = http.MultipartFile(
      'bukti_pembayaran',
      stream,
      length,
      filename: path.basename(payment.buktiPembayaran.path),
    );
    request.files.add(multipartFile);

    final response = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Request timeout');
      },
    );

    final responseBody = await response.stream.bytesToString();
    final result = jsonDecode(responseBody);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return {
        'success': true,
        'message': result['message'] ?? 'Upgrade platinum berhasil'
      };
    } else {
      return {
        'success': false,
        'message': result['message'] ?? 'Upgrade platinum gagal'
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Terjadi kesalahan: $e'
    };
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