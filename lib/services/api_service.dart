import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';

class ApiService {
  // POST request dengan JSON
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers ?? ApiConfig.headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request dengan multipart/form-data (untuk upload file)
  static Future<Map<String, dynamic>> postMultipart(
    String url,
    Map<String, String> fields, {
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields
      request.fields.addAll(fields);

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          var file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(file);
        }
      }

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Handle response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'An error occurred',
        'statusCode': response.statusCode,
      };
    }
  }
}