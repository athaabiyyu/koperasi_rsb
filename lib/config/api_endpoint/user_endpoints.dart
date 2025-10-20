import '../api_config.dart';

class UserEndpoints {
  static final String verifyOtp = '${ApiConfig.baseUrl}/user/verify-otp';
  static String getUserById(String id) => '${ApiConfig.baseUrl}/user/$id';
  static String updateUser(String id) => '${ApiConfig.baseUrl}/user/$id';
  static final String upgradePlatinum = '${ApiConfig.baseUrl}/user/upgrade-platinum';
}