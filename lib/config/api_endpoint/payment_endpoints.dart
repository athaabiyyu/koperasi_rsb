import '../api_config.dart';

class TopupEndpoints {
  // Base topup endpoint
  static final String base = '${ApiConfig.baseUrl}/topup';
  
  // Get topup history by user
  static final String getUserTopups = '$base/user';
  
  // Get topup by ID
  static String getTopupById(String id) => '$base/$id';
  
  // Get saldo topup
  static final String getSaldoTopup = '$base/saldo/user';
  
  // Get simpanan pokok
  static final String getSimpananPokok = '$base/simpanan_pokok';
  
  // Get simpanan wajib
  static final String getSimpananWajib = '$base/simpanan_wajib';
  
  // Pay member (if needed)
  static final String payMember = '$base/pay-member';
}