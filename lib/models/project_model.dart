class CreateProjectRequest {
  final String idKategori;
  final String judul;
  final String deskripsi;
  final int nominal;
  final String assetJaminan;
  final int nilaiJaminan;
  final String lokasiUsaha;
  final String detailLokasi;
  final int pendapatanPerbulan;
  final int pengeluaranPerbulan;
  final int limitSiklus;
  final int bagianPelaksana;  // ✅ Ubah dari double ke int
  final int bagianKoperasi;   // ✅ Ubah dari double ke int
  final int bagianPemilik;    // ✅ Ubah dari double ke int
  final int bagianPendana;

  // File paths
  final List<String>? dokumen;
  final String? brosurProduk;
  final String dokumenProyeksi;

  CreateProjectRequest({
    required this.idKategori,
    required this.judul,
    required this.deskripsi,
    required this.nominal,
    required this.assetJaminan,
    required this.nilaiJaminan,
    required this.lokasiUsaha,
    required this.detailLokasi,
    required this.pendapatanPerbulan,
    required this.pengeluaranPerbulan,
    required this.limitSiklus,
    required this.bagianPelaksana,
    required this.bagianKoperasi,
    required this.bagianPemilik,
    required this.bagianPendana,
    this.dokumen,
    this.brosurProduk,
    required this.dokumenProyeksi,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'judul': judul,
      'deskripsi': deskripsi,
      'nominal': nominal,
      'asset_jaminan': assetJaminan,
      'nilai_jaminan': nilaiJaminan,
      'lokasi_usaha': lokasiUsaha,
      'detail_lokasi': detailLokasi,
      'pendapatan_perbulan': pendapatanPerbulan,
      'pengeluaran_perbulan': pengeluaranPerbulan,
      'limit_siklus': limitSiklus,
      'bagian_pelaksana': bagianPelaksana,
      'bagian_koperasi': bagianKoperasi,
      'bagian_pemilik': bagianPemilik,
      'bagian_pendana': bagianPendana,
    };
  }
}

class ProjectResponse {
  final String message;
  final String? projectId;

  ProjectResponse({
    required this.message,
    this.projectId,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      message: json['message'] ?? 'Project created successfully',
      projectId: json['projectId'],
    );
  }
}

class ProjectCategory {
  final String id;
  final String name; // Tetap pakai "name" untuk konsistensi kode
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProjectCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    return ProjectCategory(
      id: json['id'] as String,
      name: json['kategori'] as String, // ✅ Baca dari "kategori"
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': name, // ✅ Kirim sebagai "kategori"
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
