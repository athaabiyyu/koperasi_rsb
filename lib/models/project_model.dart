class ProjectModel{
  final String nama;
  final String kategori;
  final String deskripsiProyek;
  //final String? dokumenPendukung; // 
  final double nominal;
  final String namaJaminan;
  final double nilaiJaminan;
  final String provinsi;
  final String kota;
  final String kecamatan;
  final String deskripsiLokasi;
  //final String? brosurProduk; //
  final double pendapatanBulanan;
  final double pengeluaranBulanan;
  //final String? dokumenProyeksi; //

  ProjectModel({
    required this.nama,
    required this.kategori,
    required this.deskripsiProyek,
    //this.dokumenPendukung,
    required this.nominal,
    required this.namaJaminan,
    required this.nilaiJaminan,
    required this.provinsi,
    required this.kota,
    required this.kecamatan,
    required this.deskripsiLokasi,
    //this.brosurProduk,
    required this.pendapatanBulanan,
    required this.pengeluaranBulanan,
    //this.dokumenProyeksi,
  });

  // Convert to Map for multipart fields
  Map<String, String> toFormFields() {
    return {
      'nama': nama,
      'kategori': kategori,
      'deskripsi_proyek': deskripsiProyek,
      //'dokumen_pendukung': dokumenPendukung ?? '',
      'nominal': nominal.toString(),
      'nama_jaminan': namaJaminan,
      'nilai_jaminan': nilaiJaminan.toString(),
      'provinsi': provinsi,
      'kota': kota,
      'kecamatan': kecamatan,
      'deskripsi_lokasi': deskripsiLokasi,
      //'brosur_produk': brosurProduk ?? '',
      'pendapatan_bulanan': pendapatanBulanan.toString(),
      'pengeluaran_bulanan': pengeluaranBulanan.toString(),
      //'dokumen_proyeksi': dokumenProyeksi ?? '',
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      deskripsiProyek: json['deskripsi_proyek'] ?? '',
      //dokumenPendukung: json['dokumen_pendukung'],
      nominal: (json['nominal'] ?? 0).toDouble(),
      namaJaminan: json['nama_jaminan'] ?? '',
      nilaiJaminan: (json['nilai_jaminan'] ?? 0).toDouble(),
      provinsi: json['provinsi'] ?? '',
      kota: json['kota'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      deskripsiLokasi: json['deskripsi_lokasi'] ?? '',
      //brosurProduk: json['brosur_produk'],
      pendapatanBulanan: (json['pendapatan_bulanan'] ?? 0).toDouble(),
      pengeluaranBulanan: (json['pengeluaran_bulanan'] ?? 0).toDouble(),
      //dokumenProyeksi: json['dokumen_proyeksi'],
    );
  }


  // Validate that all required fields are present
  bool isValid() {
    return nama.isNotEmpty &&
        kategori.isNotEmpty &&
        deskripsiProyek.isNotEmpty &&
        nominal > 0 &&
        namaJaminan.isNotEmpty &&
        nilaiJaminan > 0 &&
        provinsi.isNotEmpty &&
        kota.isNotEmpty &&
        kecamatan.isNotEmpty &&
        deskripsiLokasi.isNotEmpty &&
        pendapatanBulanan > 0 &&
        pengeluaranBulanan > 0;
  }
  
}