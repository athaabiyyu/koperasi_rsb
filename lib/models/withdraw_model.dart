class WithdrawRequest {
  final String namaBank;
  final String noRekening;
  final String namaPemilikRekening;
  final int nominal;

  WithdrawRequest({
    required this.namaBank,
    required this.noRekening,
    required this.namaPemilikRekening,
    required this.nominal,
  });

  Map<String, dynamic> toJson() => {
        'nama_bank': namaBank,
        'no_rekening': noRekening,
        'nama_pemilik_rekening': namaPemilikRekening,
        'nominal': nominal,
      };
}

class TopupResponse {
  final TopupData? topup;
  final WalletData? wallet;
  final UserData? user;

  TopupResponse({
    this.topup,
    this.wallet,
    this.user,
  });

  factory TopupResponse.fromJson(Map<String, dynamic> json) {
    return TopupResponse(
      topup: json['topup'] != null ? TopupData.fromJson(json['topup']) : null,
      wallet: json['wallet'] != null ? WalletData.fromJson(json['wallet']) : null,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class TopupData {
  final String id;
  final String idUser;
  final String idWallet;
  final int nominal;
  final String jenis;
  final String status;
  final String? buktiPembayaran;
  final String? namaBank;
  final String? noRekening;
  final String? namaPemilikRekening;
  final DateTime createdAt;
  final DateTime updatedAt;

  TopupData({
    required this.id,
    required this.idUser,
    required this.idWallet,
    required this.nominal,
    required this.jenis,
    required this.status,
    this.buktiPembayaran,
    this.namaBank,
    this.noRekening,
    this.namaPemilikRekening,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopupData.fromJson(Map<String, dynamic> json) {
    return TopupData(
      id: json['id'] ?? '',
      idUser: json['id_user'] ?? '',
      idWallet: json['id_wallet'] ?? '',
      nominal: json['nominal'] ?? 0,
      jenis: json['jenis'] ?? '',
      status: json['status'] ?? '',
      buktiPembayaran: json['bukti_pembayaran'],
      namaBank: json['nama_bank'],
      noRekening: json['no_rekening'],
      namaPemilikRekening: json['nama_pemilik_rekening'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }
}

class WalletData {
  final String id;
  final String idUser;
  final int saldo;

  WalletData({
    required this.id,
    required this.idUser,
    required this.saldo,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['id'] ?? '',
      idUser: json['id_user'] ?? '',
      saldo: json['saldo'] ?? 0,
    );
  }
}

class UserData {
  final String id;
  final String nama;
  final String? email;

  UserData({
    required this.id,
    required this.nama,
    this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'],
    );
  }
}