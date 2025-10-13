import '../api_config.dart';

class AuthEndpoints {
  static final String register = '${ApiConfig.baseUrl}/auth/register';
  static final String login = '${ApiConfig.baseUrl}/auth/login';
  static final String logout = '${ApiConfig.baseUrl}/auth/logout';
}