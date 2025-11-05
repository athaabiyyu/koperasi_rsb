import '../api_config.dart';

class TokenEndpoints {
  static final String base = '${ApiConfig.baseUrl}/token';

  static String buyToken() {
    return '$base/buy-token';
  }
}