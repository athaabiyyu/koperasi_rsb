import '../api_config.dart';

class AuthEndpoints {
  static const String register = '${ApiConfig.baseUrl}/auth/register';
  static const String login = '${ApiConfig.baseUrl}/auth/login';
  static const String logout = '${ApiConfig.baseUrl}/auth/logout';
}