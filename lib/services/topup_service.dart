import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/config/api_endpoint/payment_endpoints.dart';
import 'package:koperasi_rsb/models/topup_model.dart';

class TopupService {
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
          topups = (responseData['data'] as List)
              .map((item) => TopupModel.fromJson(item))
              .toList();
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