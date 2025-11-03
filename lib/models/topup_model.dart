class TopupModel {
  final String id;
  final String idWallet;
  final String? nama;              
  final String? namaBank;          
  final String? noRekening;        
  final String? namaPemilikRekening; 
  final double nominal;
  final String? jenis;             
  final String status;
  final String? paymentMethod;
  final String? paymentProof;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final WalletData? wallet;
  final UserData? user;

  TopupModel({
    required this.id,
    required this.idWallet,
    this.nama,
    this.namaBank,
    this.noRekening,
    this.namaPemilikRekening,
    required this.nominal,
    this.jenis,
    required this.status,
    this.paymentMethod,
    this.paymentProof,
    required this.createdAt,
    this.updatedAt,
    this.wallet,
    this.user,
  });

  factory TopupModel.fromJson(Map<String, dynamic> json) {
    // Handle nested structure from backend
    final topupData = json['topup'] ?? json;
    final walletData = json['wallet'];
    final userData = json['user'];

    return TopupModel(
      id: topupData['id'] ?? '',
      idWallet: topupData['id_wallet'] ?? '',
      nama: topupData['nama'],                              
      namaBank: topupData['nama_bank'],                     
      noRekening: topupData['no_rekening'],                 
      namaPemilikRekening: topupData['nama_pemilik_rekening'], 
      nominal: (topupData['nominal'] ?? 0).toDouble(),
      jenis: topupData['jenis'],                            
      status: topupData['status'] ?? 'MENUNGGU KONFIRMASI',
      paymentMethod: topupData['payment_method'],
      paymentProof: topupData['bukti_pembayaran'] ?? topupData['payment_proof'],
      createdAt: DateTime.parse(topupData['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: topupData['updated_at'] != null 
          ? DateTime.parse(topupData['updated_at']) 
          : null,
      wallet: walletData != null ? WalletData.fromJson(walletData) : null,
      user: userData != null ? UserData.fromJson(userData) : null,
    );
  }

  // ✅ FIXED: Handle uppercase status dari backend
  bool get isSuccess => status.toUpperCase() == 'SUKSES' || 
                        status.toLowerCase() == 'success' || 
                        status.toLowerCase() == 'berhasil';
  
  bool get isPending => status.toUpperCase() == 'MENUNGGU KONFIRMASI' || 
                        status.toUpperCase() == 'PENDING' ||
                        status.toLowerCase() == 'menunggu' ||
                        status.toLowerCase() == 'pending';

  bool get isFailed => status.toUpperCase() == 'GAGAL' || 
                       status.toUpperCase() == 'FAILED' ||
                       status.toLowerCase() == 'gagal' ||
                       status.toLowerCase() == 'failed';
  
  String get displayStatus {
    switch (status.toUpperCase()) {
      case 'SUKSES':
      case 'SUCCESS':
      case 'BERHASIL':
        return 'Berhasil';
      case 'MENUNGGU KONFIRMASI':
      case 'PENDING':
      case 'MENUNGGU':
        return 'Menunggu Konfirmasi';
      case 'GAGAL':
      case 'FAILED':
        return 'Gagal';
      default:
        return status;
    }
  }

  String get displayTransactionType {
    if (jenis != null && jenis!.isNotEmpty) {
      return jenis!;
    }
    return 'Top Up';
  }

  String get displayDate {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';
  }

  String get displayAmount {
    return 'Rp ${nominal.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}

class WalletData {
  final String id;
  final String idUser;
  final double balance;

  WalletData({
    required this.id,
    required this.idUser,
    required this.balance,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['id'] ?? '',
      idUser: json['id_user'] ?? '',
      balance: (json['saldo'] ?? json['balance'] ?? 0).toDouble(),
    );
  }
}

class UserData {
  final String id;
  final String? name;
  final String? email;

  UserData({
    required this.id,
    this.name,
    this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? json['nama'],
      email: json['email'],
    );
  }
}