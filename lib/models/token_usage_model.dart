import '../utils/url_helper.dart';

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
  final String? brosurProduk;
  final List<SupportDocument>? dokumenTambahan;

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
    this.brosurProduk,
    this.dokumenTambahan,
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
      brosurProduk: json['brosur_produk'],
      dokumenTambahan: (json['dokumenTambahan'] as List?)
              ?.map((doc) => SupportDocument.fromJson(doc))
              .toList() ??
          [],
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
      'brosur_produk': brosurProduk,
      'dokumenTambahan': dokumenTambahan?.map((doc) => doc.toJson()).toList(),
    };
  }

  // Dynamic image URL getter - same logic as ProjectListItem
  String get imageUrl {
    if (brosurProduk != null && brosurProduk!.isNotEmpty) {
      return UrlHelper.getFullImageUrl(brosurProduk);
    }
    if (dokumenTambahan != null && dokumenTambahan!.isNotEmpty) {
      return UrlHelper.getFullImageUrl(dokumenTambahan!.first.url);
    }
    return 'https://via.placeholder.com/400x300?text=No+Image';
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
    // Handle BERJALAN SIKLUS X format
    if (status.startsWith('BERJALAN SIKLUS')) {
      return status.replaceAll('BERJALAN SIKLUS', 'Proyek Berjalan - Siklus');
    }
    
    switch (status.toUpperCase()) {
      case 'PENDANAAN DIBUKA':
        return 'Pendanaan Dibuka';
      case 'BERJALAN':
        return 'Proyek Berjalan';
      case 'SELESAI':
      case 'COMPLETED':
        return 'Proyek Selesai';
      case 'DIBATALKAN':
        return 'Proyek Dibatalkan';
      case 'DRAFT':
        return 'Draft';
      case 'PROSES VERIFIKASI':
        return 'Proses Verifikasi';
      case 'REVISI':
        return 'Revisi';
      case 'APPROVAL':
        return 'Approval';
      case 'TTD KONTRAK':
        return 'TTD Kontrak';
      case 'DITOLAK':
      case 'REJECTED':
        return 'Ditolak';
      case 'PUBLISHED':
        return 'Proyek Berjalan';
      default:
        return status;
    }
  }

  // Check if project is completed
  bool get isCompleted => 
      status.toUpperCase() == 'COMPLETED' || 
      status.toUpperCase() == 'SELESAI';
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

class SupportDocument {
  final String id;
  final String idProjek;
  final String jenis;
  final String url;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SupportDocument({
    required this.id,
    required this.idProjek,
    required this.jenis,
    required this.url,
    required this.createdAt,
    this.updatedAt,
  });

  factory SupportDocument.fromJson(Map<String, dynamic> json) {
    // Backend mengirim field 'dokumen', bukan 'url'
    final dokumenUrl = json['dokumen'] ?? json['url'] ?? '';
    
    // Jika tidak ada field 'jenis', extract dari nama file
    String jenis = json['jenis'] ?? '';
    if (jenis.isEmpty && dokumenUrl.isNotEmpty) {
      jenis = _extractFileNameFromUrl(dokumenUrl);
    }
    
    return SupportDocument(
      id: json['id'] ?? '',
      idProjek: json['id_projek'] ?? '',
      jenis: jenis.isNotEmpty ? jenis : 'Dokumen Pendukung',
      url: dokumenUrl,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_projek': idProjek,
      'jenis': jenis,
      'dokumen': url,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  // Helper untuk extract nama file dari URL
  static String _extractFileNameFromUrl(String url) {
    if (url.isEmpty) return 'Dokumen Pendukung';
    
    try {
      final parts = url.split('/');
      final fileName = parts.isNotEmpty ? parts.last : 'Dokumen';
      
      // Remove timestamp prefix (1761539892871-)
      final cleanName = fileName.replaceFirst(RegExp(r'^\d+-'), '');
      
      // Remove extension
      final nameWithoutExt = cleanName.split('.').first;
      
      // Format nama: replace dash/underscore dengan space, capitalize
      return nameWithoutExt
          .replaceAll(RegExp(r'[-_]'), ' ')
          .split(' ')
          .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
          .join(' ');
    } catch (e) {
      return 'Dokumen Pendukung';
    }
  }
}