// lib/services/project_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/project_model.dart';
import '../utils/shared_preferences_helper.dart';

class ProjectService {
  // Get token dari SharedPreferencesHelper
  Future<String?> _getToken() async {
    return await SharedPreferencesHelper.getToken();
  }

  // ⭐ NEW: Get project categories from API
  Future<List<ProjectCategory>> getProjectCategories({String? search}) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      // Build URL with optional search parameter
      var url = '${ApiConfig.baseUrl}/project-category';
      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // Handle different response structures
        List<dynamic> categoriesData;
        if (jsonResponse is List) {
          categoriesData = jsonResponse;
        } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          categoriesData = jsonResponse['data'] as List;
        } else if (jsonResponse is Map && jsonResponse.containsKey('categories')) {
          categoriesData = jsonResponse['categories'] as List;
        } else {
          throw Exception('Format response tidak valid');
        }

        final categories = categoriesData
            .map((json) => ProjectCategory.fromJson(json))
            .toList();

        return categories;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat kategori');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<ProjectResponse> createProject({
    required CreateProjectRequest project,
    List<File>? dokumenFiles,
    File? brosurProdukFile,
    required File dokumenProyeksiFile,
  }) async {
    try {
      
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }
      final uri = Uri.parse('${ApiConfig.baseUrl}/project');
      final request = http.MultipartRequest('POST', uri);
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add all form fields
      final jsonData = project.toJson();
      jsonData.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      
      // Add dokumen files (multiple files)
      if (dokumenFiles != null && dokumenFiles.isNotEmpty) {
        for (var file in dokumenFiles) {
          final multipartFile = await http.MultipartFile.fromPath(
            'dokumen',
            file.path,
            contentType: MediaType('application', 'octet-stream'),
          );
          request.files.add(multipartFile);
        }
      }

      // Add brosur_produk file (optional)
      if (brosurProdukFile != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'brosur_produk',
          brosurProdukFile.path,
          contentType: MediaType('application', 'octet-stream'),
        );
        request.files.add(multipartFile);
      } else {

      }

      // Add dokumen_proyeksi file (required)
      final proyeksiFile = await http.MultipartFile.fromPath(
        'dokumen_proyeksi',
        dokumenProyeksiFile.path,
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(proyeksiFile);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return ProjectResponse.fromJson(jsonResponse);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['error'] ?? 
                           errorBody['message'] ?? 
                           'Gagal membuat proyek';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  // Save draft menggunakan SharedPreferences
  Future<void> saveDraft(Map<String, dynamic> draftData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('project_draft', json.encode(draftData));
    } catch (e) {
      throw Exception('Gagal menyimpan draft: ${e.toString()}');
    }
  }

  // Get saved draft
  Future<Map<String, dynamic>?> getDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftString = prefs.getString('project_draft');
      if (draftString != null && draftString.isNotEmpty) {
        return json.decode(draftString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal memuat draft: ${e.toString()}');
    }
  }

  // Clear draft
  Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('project_draft');
    } catch (e) {
      throw Exception('Gagal menghapus draft: ${e.toString()}');
    }
  }
}