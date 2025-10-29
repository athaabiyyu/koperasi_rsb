import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/config/api_endpoint/payment_endpoints.dart';
import 'package:koperasi_rsb/models/topup_model.dart';

class TopupService {
  static Future<Map<String, dynamic>> payTopup({
    required String token,
    required String namaBank,
    required String noRekening,
    required String namaPemilikRekening,
    required int nominal,
    required File buktiPembayaran,
  }) async {
    try {
      if (!buktiPembayaran.existsSync()) {
        return {
          'success': false,
          'message': 'File bukti pembayaran tidak ditemukan',
        };
      }

      final url = Uri.parse('${TopupEndpoints.payTopup}');
      var request = http.MultipartRequest('POST', url);

      final headers = ApiConfig.getAuthHeaders(token);
      request.headers.addAll(headers);
      request.fields['nama_bank'] = namaBank;
      request.fields['no_rekening'] = noRekening;
      request.fields['nama_pemilik_rekening'] = namaPemilikRekening;
      request.fields['nominal'] = nominal.toString();

      final multipartFile = await http.MultipartFile.fromPath(
        'bukti_pembayaran',
        buktiPembayaran.path,
      );
      request.files.add(multipartFile);
    
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          final message = responseData['message'] ?? 'Topup created, awaiting payment confirmation';
          
          return {
            'success': true,
            'message': message,
          };
        } catch (parseError) {
          return {
            'success': false,
            'message': 'Gagal memproses response dari server',
          };
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Gagal melakukan topup';
          
          return {
            'success': false,
            'message': errorMessage,
          };
        } catch (parseError) {
          return {
            'success': false,
            'message': 'Server error: ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // ✅ NEW: Pay Simpanan Wajib
 // Tambahkan method baru di class TopupService
static Future<Map<String, dynamic>> paySimpananWajib({
  required String token,
  required String namaBank,
  required String noRekening,
  required String namaPemilikRekening,
  required File buktiPembayaran,
}) async {
  try {
    if (!buktiPembayaran.existsSync()) {
      return {
        'success': false,
        'message': 'File bukti pembayaran tidak ditemukan',
      };
    }

    final url = Uri.parse('${TopupEndpoints.paySimpananWajib}');
    var request = http.MultipartRequest('POST', url);

    final headers = ApiConfig.getAuthHeaders(token);
    request.headers.addAll(headers);
    request.fields['nama_bank'] = namaBank;
    request.fields['no_rekening'] = noRekening;
    request.fields['nama_pemilik_rekening'] = namaPemilikRekening;
    request.fields['nominal'] = '120000'; // Statis 120.000

    final multipartFile = await http.MultipartFile.fromPath(
      'bukti_pembayaran',
      buktiPembayaran.path,
    );
    request.files.add(multipartFile);
  
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);
        final message = responseData['message'] ?? 'Simpanan Wajib created, awaiting payment confirmation';
        
        return {
          'success': true,
          'message': message,
        };
      } catch (parseError) {
        return {
          'success': false,
          'message': 'Gagal memproses response dari server',
        };
      }
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal melakukan pembayaran simpanan wajib';
        
        return {
          'success': false,
          'message': errorMessage,
        };
      } catch (parseError) {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Terjadi kesalahan: $e',
    };
  }
}

  // Get topup history by user ID
  static Future<Map<String, dynamic>> getTopupByUserId(String token) async {
    try {
      final url = Uri.parse(TopupEndpoints.getUserTopups);
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        List<TopupModel> topups = [];
        if (responseData['data'] != null) {
          topups = (responseData['data'] as List).map((item) {
            try {
              return TopupModel.fromJson(item);
            } catch (e) {
              rethrow;
            }
          }).toList();
        }

        return {
          'success': true,
          'message': responseData['message'] ?? 'Topups found',
          'data': topups,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'message': 'Belum ada riwayat topup',
          'data': <TopupModel>[],
        };
      } else {
        final errorData = json.decode(response.body);

        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil data topup',
          'data': <TopupModel>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'data': <TopupModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getTopupById(String token, String topupId) async {
    try {
      final url = Uri.parse(TopupEndpoints.getTopupById(topupId));
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final topup = TopupModel.fromJson(responseData['data'][0]);

        return {
          'success': true,
          'message': responseData['message'],
          'data': topup,
        };
      } else {
        final errorData = json.decode(response.body);

        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil detail topup',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Get saldo topup
  static Future<Map<String, dynamic>> getSaldoTopup(String token) async {
    try {
      final url = Uri.parse(TopupEndpoints.getSaldoTopup);
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final total = responseData['total'] ?? 0;

        return {
          'success': true,
          'message': responseData['message'] ?? 'Saldo topup retrieved',
          'total': total,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'message': 'No saldo found',
          'total': 0,
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil saldo topup',
          'total': 0,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'total': 0,
      };
    }
  }

  // Get simpanan pokok
  static Future<Map<String, dynamic>> getSimpananPokok(String token) async {
    try {
      final url = Uri.parse(TopupEndpoints.getSimpananPokok);
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final total = responseData['total'] ?? 0;
      
        return {
          'success': true,
          'message': responseData['message'] ?? 'Simpanan pokok retrieved',
          'total': total,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'message': 'No simpanan pokok found',
          'total': 0,
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil simpanan pokok',
          'total': 0,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'total': 0,
      };
    }
  }

  // Get simpanan wajib
  static Future<Map<String, dynamic>> getSimpananWajib(String token) async {
    try {
      final url = Uri.parse(TopupEndpoints.getSimpananWajib);
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final total = responseData['total'] ?? 0;
        return {
          'success': true,
          'message': responseData['message'] ?? 'Simpanan wajib retrieved',
          'total': total,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'message': 'No simpanan wajib found',
          'total': 0,
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil simpanan wajib',
          'total': 0,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'total': 0,
      };
    }
  }
}