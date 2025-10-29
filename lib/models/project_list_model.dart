// lib/models/project_list_model.dart
import '../utils/url_helper.dart';

class ProjectListItem {
  final String id;
  final String idUser;
  final String idKategori;
  final String judul;
  final String deskripsi;
  final int nominal;
  final String assetJaminan;
  final int nilaiJaminan;
  final String lokasiUsaha;
  final String detailLokasi;
  final String? brosurProduk;
  final int pendapatanPerbulan;
  final int pengeluaranPerbulan;
  final String? reportProgress;
  final String dokumenProyeksi;
  final String status;
  final int? nominalDisetujui;
  final int? hargaPerUnit;
  final int? jumlahKoin;
  final int? minimalPembelian;
  final int? maksimalPembelian;
  final DateTime? mulaiPenggalanganDana;
  final DateTime? selesaiPenggalanganDana;
  final String? dokumenProspektus;
  final int? limitSiklus;
  final int? bagianPelaksana;
  final int? bagianKoperasi;
  final int? bagianPemilik;
  final int? bagianPendana;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserInfo user;
  final CategoryInfo kategori;
  final List<SupportDocument> dokumenTambahan;

  ProjectListItem({
    required this.id,
    required this.idUser,
    required this.idKategori,
    required this.judul,
    required this.deskripsi,
    required this.nominal,
    required this.assetJaminan,
    required this.nilaiJaminan,
    required this.lokasiUsaha,
    required this.detailLokasi,
    this.brosurProduk,
    required this.pendapatanPerbulan,
    required this.pengeluaranPerbulan,
    this.reportProgress,
    required this.dokumenProyeksi,
    required this.status,
    this.nominalDisetujui,
    this.hargaPerUnit,
    this.jumlahKoin,
    this.minimalPembelian,
    this.maksimalPembelian,
    this.mulaiPenggalanganDana,
    this.selesaiPenggalanganDana,
    this.dokumenProspektus,
    this.limitSiklus,
    this.bagianPelaksana,
    this.bagianKoperasi,
    this.bagianPemilik,
    this.bagianPendana,
    required this.createdAt,
    this.updatedAt,
    required this.user,
    required this.kategori,
    required this.dokumenTambahan,
  });

  factory ProjectListItem.fromJson(Map<String, dynamic> json) {
    return ProjectListItem(
      id: json['id'] ?? '',
      idUser: json['id_user'] ?? '',
      idKategori: json['id_kategori'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      nominal: json['nominal'] ?? 0,
      assetJaminan: json['asset_jaminan'] ?? '',
      nilaiJaminan: json['nilai_jaminan'] ?? 0,
      lokasiUsaha: json['lokasi_usaha'] ?? '',
      detailLokasi: json['detail_lokasi'] ?? '',
      brosurProduk: json['brosur_produk'],
      pendapatanPerbulan: json['pendapatan_perbulan'] ?? 0,
      pengeluaranPerbulan: json['pengeluaran_perbulan'] ?? 0,
      reportProgress: json['report_progress'],
      dokumenProyeksi: json['dokumen_proyeksi'] ?? '',
      status: json['status'] ?? 'DRAFT',
      nominalDisetujui: json['nominal_disetujui'],
      hargaPerUnit: json['harga_per_unit'],
      jumlahKoin: json['jumlah_koin'],
      minimalPembelian: json['minimal_pembelian'],
      maksimalPembelian: json['maksimal_pembelian'],
      mulaiPenggalanganDana: json['mulai_penggalangan_dana'] != null
          ? DateTime.parse(json['mulai_penggalangan_dana'])
          : null,
      selesaiPenggalanganDana: json['selesai_penggalangan_dana'] != null
          ? DateTime.parse(json['selesai_penggalangan_dana'])
          : null,
      dokumenProspektus: json['dokumen_prospektus'],
      limitSiklus: json['limit_siklus'],
      bagianPelaksana: json['bagian_pelaksana'],
      bagianKoperasi: json['bagian_koperasi'],
      bagianPemilik: json['bagian_pemilik'],
      bagianPendana: json['bagian_pendana'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      user: UserInfo.fromJson(json['user'] ?? {}),
      kategori: CategoryInfo.fromJson(json['kategori'] ?? {}),
      dokumenTambahan: (json['dokumenTambahan'] as List?)
              ?.map((doc) => SupportDocument.fromJson(doc))
              .toList() ??
          [],
    );
  }
  String get mainImageUrl {
    if (brosurProduk != null && brosurProduk!.isNotEmpty) {
      return UrlHelper.getFullImageUrl(brosurProduk);
    }
    if (dokumenTambahan.isNotEmpty) {
      return UrlHelper.getFullImageUrl(dokumenTambahan.first.url);
    }
    return 'https://via.placeholder.com/400x300?text=No+Image';
  }

  String get statusDisplay {
    // Handle BERJALAN SIKLUS X
    if (status.startsWith('BERJALAN SIKLUS')) {
      return status.replaceAll('BERJALAN SIKLUS', 'Proyek Berjalan - Siklus');
    }
    
    switch (status) {
      case 'PENDANAAN DIBUKA':
        return 'Pendanaan Dibuka';
      case 'BERJALAN':
        return 'Proyek Berjalan';
      case 'SELESAI':
        return 'Proyek Selesai';
      case 'DIBATALKAN':
        return 'Proyek Dibatalkan';
      case 'DRAFT':
        return 'Draft Proyek';
      case 'PROSES VERIFIKASI':
        return 'Proses Verifikasi';
      case 'REVISI':
        return 'Revisi';
      case 'APPROVAL':
        return 'Approval';
      case 'TTD KONTRAK':
        return 'TTD Kontrak';
      case 'DITOLAK':
        return 'Ditolak';
      default:
        return status;
    }
  }

  // Helper: Check if draft
  bool get isDraft => status == 'DRAFT';

  // Helper: Check if pending verification
  bool get isPendingVerification =>
      status == 'PROSES VERIFIKASI' || 
      status == 'REVISI' || 
      status == 'APPROVAL' ||
      status == 'TTD KONTRAK' ||
      status == 'DITOLAK';

  // Helper: Check if project is running (including all cycles)
  bool get isRunning => status == 'BERJALAN' || status.startsWith('BERJALAN SIKLUS');

  // Helper: Calculate remaining days
  int get sisaHari {
    if (selesaiPenggalanganDana == null) return 0;
    final now = DateTime.now();
    final difference = selesaiPenggalanganDana!.difference(now);
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  // Helper: Calculate funding progress (if you have funding data)
  double get fundingProgress {
    if (nominalDisetujui == null || nominalDisetujui == 0) return 0;
    // This would need actual collected amount from funding transactions
    // For now, return 0 as placeholder
    return 0;
  }
  

  // Helper: Get token info
  int get tokenDitawarkan => jumlahKoin ?? 0;
  int get minBeli => minimalPembelian ?? 0;
  int get maxBeli => maksimalPembelian ?? 0;

  // Helper: Check if funding is active
  bool get isFundingActive {
    if (status != 'PENDANAAN DIBUKA') return false;
    if (mulaiPenggalanganDana == null || selesaiPenggalanganDana == null) {
      return false;
    }
    final now = DateTime.now();
    return now.isAfter(mulaiPenggalanganDana!) &&
        now.isBefore(selesaiPenggalanganDana!);
  }

  // Helper: Check if profit sharing is defined
  bool get hasProfitSharing =>
      bagianPelaksana != null &&
      bagianKoperasi != null &&
      bagianPemilik != null &&
      bagianPendana != null;

  // Helper: Get total profit sharing percentage
  int get totalProfitSharing {
    if (!hasProfitSharing) return 0;
    return (bagianPelaksana ?? 0) +
        (bagianKoperasi ?? 0) +
        (bagianPemilik ?? 0) +
        (bagianPendana ?? 0);
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? json['nama'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['no_hp'],
      avatar: json['avatar'] ?? json['foto_profil'],
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;
  final String? description;

  CategoryInfo({
    required this.id,
    required this.name,
    this.description,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? json['nama'] ?? '',
      description: json['description'] ?? json['deskripsi'],
    );
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
      url: dokumenUrl, // ✅ Ambil dari field 'dokumen'
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
  
  // Helper untuk extract nama file dari URL
  static String _extractFileNameFromUrl(String url) {
    if (url.isEmpty) return 'Dokumen Pendukung';
    
    try {
      // Ambil nama file dari path
      // uploads/dokumen_pendukung/1761539892871-Lenovo-LOQ-Luna-Grey-6.png
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