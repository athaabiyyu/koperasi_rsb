import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/wilayah_model.dart';
import '../config/api_endpoint/api_endpoints.dart';

class WilayahService {
  // Get all provinces
  Future<List<Province>> getProvinces() async {
    try {
      final response = await http.get(
        Uri.parse(WilayahEndpoints.provinces),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Province.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching provinces: $e');
    }
  }

  // Get regencies by province code
  Future<List<Regency>> getRegencies(String provinceCode) async {
    try {
      final response = await http.get(
        Uri.parse(WilayahEndpoints.regencies(provinceCode)),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Regency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load regencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching regencies: $e');
    }
  }

  // Get districts by regency code
  Future<List<District>> getDistricts(String regencyCode) async {
    try {
      final response = await http.get(
        Uri.parse(WilayahEndpoints.districts(regencyCode)),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => District.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load districts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching districts: $e');
    }
  }

  // Get villages by district code
  Future<List<Village>> getVillages(String districtCode) async {
    try {
      final response = await http.get(
        Uri.parse(WilayahEndpoints.villages(districtCode)),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Village.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load villages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching villages: $e');
    }
  }
}