import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../config/api_config.dart';
import 'package:mime/mime.dart';

class ProspectusService {
  // Detect file extension dari content-type atau URL
  String _getFileExtension(http.Response response, String url) {
    // Coba dari Content-Type header
    final contentType = response.headers['content-type']?.toLowerCase();
    
    if (contentType != null) {
      // PDF
      if (contentType.contains('pdf')) return 'pdf';
      // Images
      if (contentType.contains('jpeg') || contentType.contains('jpg')) return 'jpg';
      if (contentType.contains('png')) return 'png';
      if (contentType.contains('gif')) return 'gif';
      if (contentType.contains('webp')) return 'webp';
      // Documents
      if (contentType.contains('msword')) return 'doc';
      if (contentType.contains('wordprocessingml')) return 'docx';
      if (contentType.contains('ms-excel')) return 'xls';
      if (contentType.contains('spreadsheetml')) return 'xlsx';
      if (contentType.contains('ms-powerpoint')) return 'ppt';
      if (contentType.contains('presentationml')) return 'pptx';
      // Text
      if (contentType.contains('plain')) return 'txt';
    }
    
    // Fallback: coba deteksi dari URL
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    
    if (path.endsWith('.pdf')) return 'pdf';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'jpg';
    if (path.endsWith('.png')) return 'png';
    if (path.endsWith('.gif')) return 'gif';
    if (path.endsWith('.webp')) return 'webp';
    if (path.endsWith('.doc')) return 'doc';
    if (path.endsWith('.docx')) return 'docx';
    if (path.endsWith('.xls')) return 'xls';
    if (path.endsWith('.xlsx')) return 'xlsx';
    if (path.endsWith('.ppt')) return 'ppt';
    if (path.endsWith('.pptx')) return 'pptx';
    if (path.endsWith('.txt')) return 'txt';
    
    // Last resort: coba deteksi dari bytes
    final mimeType = lookupMimeType('', headerBytes: response.bodyBytes.take(12).toList());
    if (mimeType != null) {
      if (mimeType.contains('pdf')) return 'pdf';
      if (mimeType.contains('jpeg')) return 'jpg';
      if (mimeType.contains('png')) return 'png';
      if (mimeType.contains('gif')) return 'gif';
    }
    
    // Default ke pdf jika tidak terdeteksi
    return 'pdf';
  }

  // Get friendly file type name
  String _getFileTypeName(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'PDF';
      case 'jpg':
      case 'jpeg':
        return 'Gambar (JPEG)';
      case 'png':
        return 'Gambar (PNG)';
      case 'gif':
        return 'Gambar (GIF)';
      case 'webp':
        return 'Gambar (WebP)';
      case 'doc':
      case 'docx':
        return 'Dokumen Word';
      case 'xls':
      case 'xlsx':
        return 'Dokumen Excel';
      case 'ppt':
      case 'pptx':
        return 'Dokumen PowerPoint';
      case 'txt':
        return 'Dokumen Teks';
      default:
        return 'Dokumen';
    }
  }

  // Download dan buka dokumen prospektus
  Future<Map<String, dynamic>> downloadAndOpenProspectus({
    required String token,
    required String projectId,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/project/$projectId/dokumen-prospektus';
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        // Detect file extension
        final extension = _getFileExtension(response, url);
        final fileTypeName = _getFileTypeName(extension);
        
        // Get directory untuk menyimpan file
        final directory = await getApplicationDocumentsDirectory();
        
        // Buat nama file dengan timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${directory.path}/prospektus_$projectId\_$timestamp.$extension';
        
        // Simpan file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        // Buka file
        final result = await OpenFile.open(filePath);
        
        if (result.type == ResultType.done) {
          return {
            'success': true,
            'message': 'Prospektus ($fileTypeName) berhasil dibuka',
            'filePath': filePath,
            'fileType': extension,
          };
        } else if (result.type == ResultType.noAppToOpen) {
          return {
            'success': false,
            'message': 'Tidak ada aplikasi untuk membuka file $fileTypeName. File tersimpan di: ${file.path}',
            'filePath': filePath,
            'fileType': extension,
            'needsApp': true,
          };
        } else {
          return {
            'success': false,
            'message': 'Gagal membuka file: ${result.message}. File tersimpan di: ${file.path}',
            'filePath': filePath,
            'fileType': extension,
          };
        }
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Dokumen prospektus tidak ditemukan',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sesi Anda telah berakhir. Silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengunduh prospektus (Kode: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Download prospektus saja tanpa membuka
  Future<Map<String, dynamic>> downloadProspectus({
    required String token,
    required String projectId,
    String? customFileName,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/project/$projectId/dokumen-prospektus';
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        // Detect file extension
        final extension = _getFileExtension(response, url);
        final fileTypeName = _getFileTypeName(extension);
        
        // Get directory untuk menyimpan file
        final directory = await getApplicationDocumentsDirectory();
        
        // Gunakan custom filename atau default dengan timestamp
        final fileName = customFileName ?? 'prospektus_$projectId\_${DateTime.now().millisecondsSinceEpoch}.$extension';
        final filePath = '${directory.path}/$fileName';
        
        // Simpan file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        return {
          'success': true,
          'message': 'Prospektus ($fileTypeName) berhasil diunduh',
          'filePath': filePath,
          'fileType': extension,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Dokumen prospektus tidak ditemukan',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sesi Anda telah berakhir. Silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengunduh prospektus (Kode: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Cek apakah prospektus tersedia dan dapatkan info tipe file
  Future<Map<String, dynamic>> getProspectusInfo({
    required String token,
    required String projectId,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/projects/$projectId/dokumen-prospektus';
      
      final response = await http.head(
        Uri.parse(url),
        headers: ApiConfig.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type']?.toLowerCase();
        String fileType = 'unknown';
        
        if (contentType != null) {
          if (contentType.contains('pdf')) fileType = 'pdf';
          else if (contentType.contains('image')) fileType = 'image';
          else if (contentType.contains('word')) fileType = 'word';
          else if (contentType.contains('excel')) fileType = 'excel';
          else if (contentType.contains('powerpoint')) fileType = 'powerpoint';
        }
        
        return {
          'available': true,
          'fileType': fileType,
          'contentType': contentType,
        };
      } else {
        return {
          'available': false,
        };
      }
    } catch (e) {
      return {
        'available': false,
        'error': e.toString(),
      };
    }
  }
}