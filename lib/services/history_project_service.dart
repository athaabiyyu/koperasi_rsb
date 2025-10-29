import '../models/history_project_model.dart';
import '../models/timeline_status_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/shared_preferences_helper.dart';
import '../config/api_config.dart';

class HistoryProjectService {
    Future<String?> _getToken() async {
    return await SharedPreferencesHelper.getToken();
  }
  /// Get Project History by Project ID
  Future<List<HistoryProject>> getProjectHistory(String projectId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final url = '${ApiConfig.baseUrl}/history-project/project/$projectId';
      print('📡 Fetching project history from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📥 History Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('📦 History Response: $jsonResponse');

        // Handle response structure
        List<dynamic> historyData;
        if (jsonResponse is List) {
          historyData = jsonResponse;
        } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          historyData = jsonResponse['data'] as List;
        } else if (jsonResponse is Map && jsonResponse.containsKey('history')) {
          historyData = jsonResponse['history'] as List;
        } else {
          throw Exception('Format response tidak valid');
        }

        final histories = historyData
            .map((json) => HistoryProject.fromJson(json))
            .toList();

        print('✅ Loaded ${histories.length} history items');
        return histories;
        
      } else if (response.statusCode == 404) {
        print('ℹ️ No history found for project $projectId');
        return [];
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat history proyek');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      print('❌ Error loading project history: $e');
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        return [];
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Group histories by timeline steps
  List<TimelineStepData> groupHistoriesByStep(List<HistoryProject> histories) {
    final steps = [
      "Proposal Project Terkirim",
      "Peninjauan Proposal",
      "Proses Approval dari Komitee Koperasi",
      "Kontrak Perjanjian",
      "Proses Penggalangan Penyertaan Modal",
    ];

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final stepName = entry.value;
      
      // Filter histories for this step
      final stepHistories = histories
          .where((h) => h.history == stepName)
          .toList();
      
      // Sort by created_at descending (newest first)
      stepHistories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return TimelineStepData(
        stepName: stepName,
        histories: stepHistories,
        stepIndex: index,
      );
    }).toList();
  }
}