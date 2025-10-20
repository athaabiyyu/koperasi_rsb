import '../api_config.dart';

class PaymentEndpoints {
  static final String payMember = '${ApiConfig.baseUrl}/topup/pay-member';
  static final String getUserTopups = '${ApiConfig.baseUrl}/topup/user';
  static String getTopupById(String id) => '${ApiConfig.baseUrl}/topup/$id';
  
}
