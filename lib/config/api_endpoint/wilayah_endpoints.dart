import '../api_config.dart';

class WilayahEndpoints {
  static const String provinces = '${ApiConfig.baseUrl}/wilayah/provinces';
  
  static String regencies(String provinceCode) => 
      '${ApiConfig.baseUrl}/wilayah/regencies/$provinceCode';
  
  static String districts(String regencyCode) => 
      '${ApiConfig.baseUrl}/wilayah/districts/$regencyCode';
  
  static String villages(String districtCode) => 
      '${ApiConfig.baseUrl}/wilayah/villages/$districtCode';
}