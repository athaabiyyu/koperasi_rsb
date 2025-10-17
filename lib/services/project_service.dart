import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/project_model.dart';
import '../config/api_endpoint/project_endpoints.dart';

class ProjectService {
  // POST request dengan JSON
  static Future<Map<String, dynamic>> createProject(ProjectModel project, [File? dokumenPendukung, File? brosurProduk, File? dokumenProyeksi]) async {
    try{
      if(!project.isValid()){
        return {'success': false, 'message': 'Data proyek tidak lengkap'};
      }
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(ProjectEndpoints.createProject),
      );

      // ProjectModel fields
      request.fields.addAll(project.toFormFields());

      // Optional file fields
      if (dokumenPendukung != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'dokumen_pendukung',
            dokumenPendukung.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }
      if (brosurProduk != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'brosur_produk',
            brosurProduk.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }
      if (dokumenProyeksi != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'dokumen_proyeksi',
            dokumenProyeksi.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        String errorMessage = 'Pengajuan gagal';
        
        if (error['error'] != null) {
          if (error['error']['details'] != null) {
            final details = error['error']['details'] as List;
            errorMessage = details.map((d) => d['message']).join(', ');
          } else if (error['error'] is String) {
            errorMessage = error['error'];
          }
        } else if (error['message'] != null) {
          errorMessage = error['message'];
        }
        
        return {'success': false, 'message': errorMessage};
      }
    }catch(e){
      print('Exception: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }
  static Future<List<ProjectModel>> getProjectById(String id) async{
    try{
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/projects/$id'),
        headers: ApiConfig.headers,
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${res.statusCode}');
      }
    }catch(e){
      throw Exception('Error fetching projects: $e');
    }
  }
  
  static Future<List<ProjectModel>> listProjects() async{
    try{
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/projects'),
        headers: ApiConfig.headers,
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${res.statusCode}');
      }
    }catch(e){
      throw Exception('Error fetching projects: $e');
    }
  }
}