import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:koperasi_rsb/models/topup_model.dart';  


class TopupService {
  // Get topup history by user ID
  static Future<Map<String, dynamic>> getTopupByUserId(String token) async {
    try {
      print('\n=== 🔄 FETCHING TOPUP HISTORY ===');
      
      final url = Uri.parse('${ApiConfig.baseUrl}/topup/user');
      print('URL: $url');
      
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        List<TopupModel> topups = [];
        if (responseData['data'] != null) {
          topups = (responseData['data'] as List)
              .map((item) => TopupModel.fromJson(item))
              .toList();
        }

        print('✅ Successfully fetched ${topups.length} topups');
        
        return {
          'success': true,
          'message': responseData['message'] ?? 'Topups found',
          'data': topups,
        };
      } else if (response.statusCode == 404) {
        print('ℹ️ No topups found');
        return {
          'success': true,
          'message': 'Belum ada riwayat topup',
          'data': <TopupModel>[],
        };
      } else {
        final errorData = json.decode(response.body);
        print('❌ Error: ${errorData['message']}');
        
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal mengambil data topup',
          'data': <TopupModel>[],
        };
      }
    } catch (e) {
      print('❌ Exception: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'data': <TopupModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getTopupById(String token, String topupId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/topup/$topupId');
      
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
}