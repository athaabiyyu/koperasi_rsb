import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoint/api_endpoints.dart';
import '../models/project_model.dart';
import '../utils/shared_preferences_helper.dart';
import '../models/project_list_model.dart';
import '../models/agreement_model.dart';
import '../models/project_investor_model.dart';

class ProjectService {
  // Get token dari SharedPreferencesHelper
  Future<String?> _getToken() async {
    return await SharedPreferencesHelper.getToken();
  }

  Future<ProjectListItem> getProjectDetail(String projectId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse(ProjectEndpoints.getProjectDetail(projectId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Map<String, dynamic> projectData;
        if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          projectData = Map<String, dynamic>.from(jsonResponse['data'] as Map);
        } else if (jsonResponse is Map) {
          projectData = Map<String, dynamic>.from(jsonResponse);
        } else {
          throw Exception('Format response tidak valid');
        }

        return ProjectListItem.fromJson(projectData);
      } else if (response.statusCode == 404) {
        throw Exception('Proyek tidak ditemukan');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat detail proyek');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<ProjectCategory>> getProjectCategories({String? search}) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      // Build URL with optional search parameter
      var url = ProjectEndpoints.getProjectCategories();
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
        } else if (jsonResponse is Map &&
            jsonResponse.containsKey('categories')) {
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
      
      final uri = Uri.parse(ProjectEndpoints.createProject());
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

  Future<ProjectResponse> updateProject({
    required String projectId,
    required CreateProjectRequest project,
    List<File>? dokumenFiles,
    File? brosurProdukFile,
    File? dokumenProyeksiFile,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ProjectEndpoints.updateProject()),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add project ID to body
      request.fields['id'] = projectId;

      // Add all project fields
      request.fields['id_kategori'] = project.idKategori;
      request.fields['judul'] = project.judul;
      request.fields['deskripsi'] = project.deskripsi;
      request.fields['nominal'] = project.nominal.toString();
      request.fields['asset_jaminan'] = project.assetJaminan;
      request.fields['nilai_jaminan'] = project.nilaiJaminan.toString();
      request.fields['lokasi_usaha'] = project.lokasiUsaha;
      request.fields['detail_lokasi'] = project.detailLokasi;
      request.fields['pendapatan_perbulan'] =
          project.pendapatanPerbulan.toString();
      request.fields['pengeluaran_perbulan'] =
          project.pengeluaranPerbulan.toString();
      request.fields['limit_siklus'] = project.limitSiklus.toString();
      request.fields['bagian_pelaksana'] = project.bagianPelaksana.toString();
      request.fields['bagian_koperasi'] = project.bagianKoperasi.toString();
      request.fields['bagian_pemilik'] = project.bagianPemilik.toString();
      request.fields['bagian_pendana'] = project.bagianPendana.toString();

      // Add files
      if (dokumenFiles != null && dokumenFiles.isNotEmpty) {
        for (var file in dokumenFiles) {
          request.files.add(
            await http.MultipartFile.fromPath('dokumen', file.path),
          );
        }
      }

      if (brosurProdukFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'brosur_produk',
            brosurProdukFile.path,
          ),
        );
      }

      if (dokumenProyeksiFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'dokumen_proyeksi',
            dokumenProyeksiFile.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check for 200 OR 201 status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Handle response that only has "message" field
        if (data is Map && data.containsKey('message')) {
          // Return a success response object
          return ProjectResponse(
            message: data['message'] as String,
            data: null, // Backend tidak return project data
          );
        }

        // If backend returns full project data
        return ProjectResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Gagal update project: ${errorData['error'] ?? errorData['message'] ?? response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProjectListItem>> getUserProjects({
    String? status,
    String? search,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      var url = ProjectEndpoints.getUserProjects();
      List<String> queryParams = [];

      if (status != null && status.isNotEmpty) {
        queryParams.add('status=$status');
      }
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=$search');
      }

      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
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
        // Handle response with 'data' wrapper
        List<dynamic> projectsData;
        if (jsonResponse is List) {
          projectsData = jsonResponse;
        } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          projectsData = jsonResponse['data'] as List;
        } else {
          throw Exception('Format response tidak valid');
        }

        return projectsData
            .map((json) => ProjectListItem.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        // No projects found, return empty list
        return [];
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat proyek');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get all public projects (not limited to current user)
  Future<List<ProjectListItem>> getAllProjects({
    String? status,
    String? search,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      var url = ProjectEndpoints.getAllProjects();
      List<String> queryParams = [];

      if (status != null && status.isNotEmpty) {
        queryParams.add('status=$status');
      }
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=$search');
      }

      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
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
        List<dynamic> projectsData;
        if (jsonResponse is List) {
          projectsData = jsonResponse;
        } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          projectsData = jsonResponse['data'] as List;
        } else {
          throw Exception('Format response tidak valid');
        }

        return projectsData
            .map((json) => ProjectListItem.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        // No projects found, return empty list
        return [];
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat proyek');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> signAgreementLetter({
    required String projectId,
    required File signatureFile,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ProjectEndpoints.signAgreementLetter()),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add project ID
      request.fields['id_projek'] = projectId;

      // Add signature file
      var signatureMultipart = await http.MultipartFile.fromPath(
        'tanda_tangan',
        signatureFile.path,
        contentType: MediaType('image', 'png'),
      );
      request.files.add(signatureMultipart);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Gagal menandatangani kontrak';
        throw Exception(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AgreementLetter?> getAgreementByProjectId(String projectId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse(ProjectEndpoints.getAgreementByProjectId(projectId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Handle response structure
        dynamic agreementData;
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          // If response is a list, take the first item
          agreementData = jsonResponse[0];
        } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];
          if (data is List && data.isNotEmpty) {
            agreementData = data[0];
          } else if (data is Map) {
            agreementData = data;
          }
        } else if (jsonResponse is Map) {
          agreementData = jsonResponse;
        }

        if (agreementData != null) {
          return AgreementLetter.fromJson(agreementData);
        }

        return null;
      } else if (response.statusCode == 404) {
        // No agreement found yet (normal case for new projects)
        return null;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Gagal memuat surat perjanjian');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      // Don't throw error if agreement not found, return null instead
      if (e.toString().contains('404') ||
          e.toString().contains('No agreements found')) {
        return null;
      }
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

  Future<List<InvestorSummary>> getProjectInvestors(String projectId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse(ProjectEndpoints.getProjectInvestors(projectId));
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // ✅ Check if data exists (backend doesn't always send 'success' field)
        if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'] as List<dynamic>;

          final investors = data
              .map(
                (json) =>
                    InvestorSummary.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          // Sort by total token value descending
          investors.sort(
            (a, b) => b.totalNilaiToken.compareTo(a.totalNilaiToken),
          );
          return investors;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Format response tidak valid',
          );
        }
      } else if (response.statusCode == 404) {
        // No investors found - return empty list
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
          errorResponse['message'] ?? 'Gagal memuat data investor',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}