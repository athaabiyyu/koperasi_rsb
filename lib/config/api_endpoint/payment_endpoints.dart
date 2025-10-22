import '../api_config.dart';

class TopupEndpoints {

  static final String base = '${ApiConfig.baseUrl}/topup';
  static final String getUserTopups = '$base/user';
  static final String getSaldoTopup = '$base/saldo/user';
  static final String getSimpananPokok = '$base/simpanan_pokok';
  static final String getSimpananWajib = '$base/simpanan_wajib';
  static final String payMember = '$base/pay-member';
  static final String payTopup = '$base/pay-topup';
  static final String paySimpananWajib = '$base/pay-simpanan-wajib';
  static String getTopupById(String id) => '$base/$id';
}