class UserModel {
  final String nama;
  final String noHp;
  final String password;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? provinsi;
  final String? kota;
  final String? kecamatan;
  final String? alamat;
  final String? nik;
  final String role; 

  UserModel({
    required this.nama,
    required this.noHp,
    required this.password,
    this.tempatLahir,
    this.tanggalLahir,
    this.provinsi,
    this.kota,
    this.kecamatan,
    this.alamat,
    this.nik,
    this.role = 'BASIC', 
  });

  // Factory constructor to create from registration data map
  factory UserModel.fromRegistrationData(Map data) {
    return UserModel(
      nama: data['nama'] as String,
      noHp: data['no_hp'] as String,
      password: data['password'] as String,
      tempatLahir: data['tempat_lahir'] as String?,
      tanggalLahir: data['tanggal_lahir'] as String?,
      provinsi: data['provinsi'] as String?,
      kota: data['kota'] as String?,
      kecamatan: data['kecamatan'] as String?,
      alamat: data['detail_alamat'] as String?,
      nik: data['nik'] as String?,
      role: data['role'] as String? ?? 'BASIC', 
    );
  }

  // Convert to Map for multipart fields
  Map<String, String> toFormFields() {
    return {
      'nama': nama,
      'no_hp': noHp,
      'password': password,
      'tempat_lahir': tempatLahir ?? '',
      'tanggal_lahir': tanggalLahir ?? '',
      'provinsi': provinsi ?? '',
      'kota': kota ?? '',
      'kecamatan': kecamatan ?? '',
      'alamat': alamat ?? '',
      'nik': nik ?? '',
      'role': role, // ⭐ TAMBAHKAN ROLE
    };
  }

  // Validate that all required fields are present
  bool isValid() {
    return nama.isNotEmpty &&
        noHp.isNotEmpty &&
        password.isNotEmpty &&
        (tempatLahir?.isNotEmpty ?? false) &&
        (tanggalLahir?.isNotEmpty ?? false) &&
        (provinsi?.isNotEmpty ?? false) &&
        (kota?.isNotEmpty ?? false) &&
        (kecamatan?.isNotEmpty ?? false) &&
        (alamat?.isNotEmpty ?? false) &&
        (nik?.isNotEmpty ?? false) &&
        role.isNotEmpty; // 
  }
}