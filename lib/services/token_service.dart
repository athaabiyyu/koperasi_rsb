// lib/services/token_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class TokenService {
  // Buy token untuk project
  Future<Map<String, dynamic>> buyToken({
    required String token,
    required String projectId,
    required int jumlahToken,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/token/buy-token');
      
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
        // Handle error responses
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
}