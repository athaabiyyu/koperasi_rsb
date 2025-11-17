import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/chart_token_model.dart'; // Import model

// Service untuk Chart Token API
class ChartTokenService {
  // Get token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? prefs.getString('auth_token');
  }

  // Get All Chart Tokens by User ID
  Future<List<ChartTokenData>> getAllChartTokensByUserId() async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/chart-token/user');
      
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Check if response has data field
        final List<dynamic> chartTokenList;
        if (jsonData is Map && jsonData.containsKey('data')) {
          chartTokenList = jsonData['data'] as List<dynamic>;
        } else if (jsonData is List) {
          chartTokenList = jsonData;
        } else {
          throw Exception('Format response tidak valid');
        }

        return chartTokenList
            .map((item) => ChartTokenData.fromJson(item as Map<String, dynamic>))
            .toList();
            
      } else if (response.statusCode == 404) {
        // No data found, return empty list
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi login telah berakhir. Silakan login kembali.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil data chart token');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // Get Chart Data dalam format PerformancePoint
  Future<List<PerformancePoint>> getChartPerformanceData() async {
    try {
      final chartTokens = await getAllChartTokensByUserId();
      
      if (chartTokens.isEmpty) {
        return [];
      }

      // Convert to PerformancePoint
      return chartTokens.map((token) {
        return PerformancePoint(
          token.date,
          token.value,
        );
      }).toList();
      
    } catch (e) {
      rethrow;
    }
  }

  // Get Chart Data dengan filter range
  Future<Map<String, dynamic>> getChartDataWithStats() async {
    try {
      final chartTokens = await getAllChartTokensByUserId();
      
      if (chartTokens.isEmpty) {
        return {
          'data': <PerformancePoint>[],
          'totalNominal': 0.0,
          'averageNominal': 0.0,
          'dataPoints': 0,
        };
      }

      // Calculate statistics
      final totalNominal = chartTokens.fold<double>(
        0, 
        (sum, token) => sum + token.sumNominal
      );
      
      final averageNominal = totalNominal / chartTokens.length;

      // Convert to PerformancePoint
      final performanceData = chartTokens.map((token) {
        return PerformancePoint(
          token.date,
          token.value,
        );
      }).toList();

      return {
        'data': performanceData,
        'totalNominal': totalNominal,
        'averageNominal': averageNominal,
        'dataPoints': chartTokens.length,
      };
      
    } catch (e) {
      rethrow;
    }
  }
}