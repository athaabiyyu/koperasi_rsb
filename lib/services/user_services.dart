import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/config/api_endpoint/api_endpoints.dart';

class UserService {
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String token,
    required String otp,
  }) async {
    try {
      print('=== VERIFY OTP ===');
      print('URL: ${UserEndpoints.verifyOtp}');
      print('Token: ${token.substring(0, 20)}...');
      print('OTP: $otp');
      print('==================');

      final response = await http.post(
        Uri.parse(UserEndpoints.verifyOtp),
        headers: ApiConfig.getAuthHeaders(token),
        body: jsonEncode({'otp': otp}),
      );

      print('=== VERIFY OTP RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('===========================');

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
      print('=== VERIFY OTP ERROR ===');
      print('Exception: $e');
      print('========================');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Get user by ID
  Future<Map<String, dynamic>> getUserById({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(UserEndpoints.getUserById(userId)),
        headers: ApiConfig.getAuthHeaders(token),
      );

      print('=== GET USER BY ID ===');
      print('URL: ${UserEndpoints.getUserById(userId)}');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      print('=====================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data']
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal mengambil data user'
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Update user data (termasuk foto_diri, foto_ktp, foto_profile)
  Future<Map<String, dynamic>> updateUser({
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
    File? fotoDiri,
    File? fotoKtp,
    File? fotoProfile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(UserEndpoints.updateUser(userId)),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields only if provided
      if (nik != null && nik.isNotEmpty) {
        request.fields['nik'] = nik.trim();
      }
      if (nama != null && nama.isNotEmpty) {
        request.fields['nama'] = nama.trim();
      }
      if (noHp != null && noHp.isNotEmpty) {
        request.fields['no_hp'] = noHp.trim();
      }
      if (tempatLahir != null && tempatLahir.isNotEmpty) {
        request.fields['tempat_lahir'] = tempatLahir.trim();
      }
      if (tanggalLahir != null && tanggalLahir.isNotEmpty) {
        request.fields['tanggal_lahir'] = tanggalLahir.trim();
      }
      if (provinsi != null && provinsi.isNotEmpty) {
        request.fields['provinsi'] = provinsi.trim();
      }
      if (kota != null && kota.isNotEmpty) {
        request.fields['kota'] = kota.trim();
      }
      if (kecamatan != null && kecamatan.isNotEmpty) {
        request.fields['kecamatan'] = kecamatan.trim();
      }
      if (alamat != null && alamat.isNotEmpty) {
        request.fields['alamat'] = alamat.trim();
      }

      // Add files only if provided
      if (fotoDiri != null) {
        var fotoDiriMultipart = await http.MultipartFile.fromPath(
          'foto_diri',
          fotoDiri.path,
        );
        request.files.add(fotoDiriMultipart);
      }

      if (fotoKtp != null) {
        var fotoKtpMultipart = await http.MultipartFile.fromPath(
          'foto_ktp',
          fotoKtp.path,
        );
        request.files.add(fotoKtpMultipart);
      }

      if (fotoProfile != null) {
        var fotoProfileMultipart = await http.MultipartFile.fromPath(
          'foto_profile',
          fotoProfile.path,
        );
        request.files.add(fotoProfileMultipart);
      }

      print('=== UPDATE USER DEBUG ===');
      print('URL: ${UserEndpoints.updateUser(userId)}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.map((f) => f.field).join(", ")}');
      print('========================');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'User updated successfully',
          'data': data['data']
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Update gagal'
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Update data diri only
  Future<Map<String, dynamic>> updateDataDiri({
    required String userId,
    required String token,
    required String nik,
    required String nama,
    required String noHp,
    required String tempatLahir,
    required String tanggalLahir,
  }) async {
    return await updateUser(
      userId: userId,
      token: token,
      nik: nik,
      nama: nama,
      noHp: noHp,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
    );
  }

  // Update alamat only
  Future<Map<String, dynamic>> updateAlamat({
    required String userId,
    required String token,
    required String provinsi,
    required String kota,
    required String kecamatan,
    required String alamat,
  }) async {
    return await updateUser(
      userId: userId,
      token: token,
      provinsi: provinsi,
      kota: kota,
      kecamatan: kecamatan,
      alamat: alamat,
    );
  }

  // Update dokumen only
  Future<Map<String, dynamic>> updateDokumen({
    required String userId,
    required String token,
    File? fotoDiri,
    File? fotoKtp,
  }) async {
    return await updateUser(
      userId: userId,
      token: token,
      fotoDiri: fotoDiri,
      fotoKtp: fotoKtp,
    );
  }
}