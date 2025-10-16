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

    // ✅ DEBUG: Print untuk melihat data yang diterima
    print('📦 Parsing topup data:');
    print('  - jenis: ${topupData['jenis']}');
    print('  - nama: ${topupData['nama']}');
    print('  - status: ${topupData['status']}');
    print('  - nominal: ${topupData['nominal']}');

    return TopupModel(
      id: topupData['id'] ?? '',
      idWallet: topupData['id_wallet'] ?? '',
      nama: topupData['nama'],                              // ✅ Parse nama
      namaBank: topupData['nama_bank'],                     // ✅ Parse nama_bank
      noRekening: topupData['no_rekening'],                 // ✅ Parse no_rekening
      namaPemilikRekening: topupData['nama_pemilik_rekening'], // ✅ Parse nama_pemilik_rekening
      nominal: (topupData['nominal'] ?? 0).toDouble(),
      jenis: topupData['jenis'],                            // ✅ Parse jenis (KEY FIELD!)
      status: topupData['status'] ?? 'pending',
      paymentMethod: topupData['payment_method'],
      paymentProof: topupData['bukti_pembayaran'] ?? topupData['payment_proof'], // ✅ Handle both field names
      createdAt: DateTime.parse(topupData['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: topupData['updated_at'] != null 
          ? DateTime.parse(topupData['updated_at']) 
          : null,
      wallet: walletData != null ? WalletData.fromJson(walletData) : null,
      user: userData != null ? UserData.fromJson(userData) : null,
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success' || status.toLowerCase() == 'berhasil';
  bool get isPending => status.toLowerCase() == 'pending' || status.toLowerCase() == 'menunggu';
  
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'success':
      case 'berhasil':
        return 'Berhasil';
      case 'pending':
      case 'menunggu':
        return 'Menunggu Konfirmasi';
      case 'failed':
      case 'gagal':
        return 'Gagal';
      default:
        return status;
    }
  }

  // ✅ ADDED: Display jenis transaksi yang dinamis
  String get displayTransactionType {
    if (jenis != null && jenis!.isNotEmpty) {
      return jenis!;
    }
    return 'Top Up'; // fallback
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
      balance: (json['saldo'] ?? json['balance'] ?? 0).toDouble(), // ✅ Handle both field names
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