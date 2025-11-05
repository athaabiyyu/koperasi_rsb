class TokenUsageDetail {
  final String id;
  final String judul;
  final String deskripsi;
  final String status;
  final int? jumlahKoin;
  final TokenUsageUser user;
  final String tokenCount;
  final String totalNominal;
  final String persentase;
  final String? imageUrl;

  TokenUsageDetail({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.status,
    this.jumlahKoin,
    required this.user,
    required this.tokenCount,
    required this.totalNominal,
    required this.persentase,
    this.imageUrl,
  });

  factory TokenUsageDetail.fromJson(Map<String, dynamic> json) {
    return TokenUsageDetail(
      id: json['id'] ?? '',
      judul: json['judul'] ?? '-',
      deskripsi: json['deskripsi'] ?? '-',
      status: json['status'] ?? 'draft',
      jumlahKoin: json['jumlah_koin'],
      user: TokenUsageUser.fromJson(json['user'] ?? {}),
      tokenCount: json['token_count']?.toString() ?? '0',
      totalNominal: json['total_nominal']?.toString() ?? '0',
      persentase: json['persentase']?.toString() ?? '0',
      imageUrl: json['brosur_produk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'status': status,
      'jumlah_koin': jumlahKoin,
      'user': user.toJson(),
      'token_count': tokenCount,
      'total_nominal': totalNominal,
      'persentase': persentase,
      'brosur_produk': imageUrl,
    };
  }

  // Get formatted token count
  int get tokenCountInt => int.tryParse(tokenCount) ?? 0;

  // Get formatted total nominal as int
  int get totalNominalInt => int.tryParse(totalNominal) ?? 0;

  // Get formatted percentage as double
  double get persentaseDouble => double.tryParse(persentase) ?? 0.0;

  // Format rupiah
  String get formattedNominal {
    if (totalNominalInt == 0) return 'Rp 0';
    
    final s = totalNominalInt.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  // Get status label in Indonesian
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'published':
        return 'Proyek Berjalan';
      case 'completed':
        return 'Proyek Selesai';
      case 'draft':
        return 'Draft';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }

  // Check if project is completed
  bool get isCompleted => status.toLowerCase() == 'completed';
}

class TokenUsageUser {
  final String id;
  final String nama;
  final String? email;

  TokenUsageUser({
    required this.id,
    required this.nama,
    this.email,
  });

  factory TokenUsageUser.fromJson(Map<String, dynamic> json) {
    return TokenUsageUser(
      id: json['id'] ?? '',
      nama: json['nama'] ?? 'Unknown',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
    };
  }
}