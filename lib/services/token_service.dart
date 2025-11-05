import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koperasi_rsb/config/api_endpoint/token_endpoints.dart';
import '../config/api_config.dart';
import '../models/token_usage_model.dart';

class TokenService {
  // Beli token untuk project
  Future<Map<String, dynamic>> buyToken({
    required String token,
    required String projectId,
    required int jumlahToken,
  }) async {
    try {
      final url = Uri.parse(TokenEndpoints.buyToken());

      final response = await http.post(
        url,
        headers: ApiConfig.getAuthHeaders(token),
        body: jsonEncode({
          'id_projek': projectId,
          'jumlah_token': jumlahToken,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Token berhasil dibeli',
          'data': responseData['data'],
        };
      } else {
        String errorMessage = 'Gagal membeli token';

        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'];
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Get token usage details by user
  Future<List<TokenUsageDetail>> getTokenUsageDetails(String token) async {
    try {
      final url = Uri.parse(TokenEndpoints.tokenUsageDetails());

      print('\n📊 === FETCHING TOKEN USAGE DETAILS ===');
      print('URL: $url');

      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          final usageList = dataList
              .map((json) => TokenUsageDetail.fromJson(json))
              .toList();

          print('✅ Loaded ${usageList.length} token usage details');
          return usageList;
        } else {
          print('⚠️ No data in response');
          return [];
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal memuat data token usage';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception in getTokenUsageDetails: $e');
      throw Exception('Gagal memuat token usage details: ${e.toString()}');
    }
  }
}