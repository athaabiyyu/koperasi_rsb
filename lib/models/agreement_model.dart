class AgreementLetter {
  final String idProjek;
  final String idUser;
  final String namaProyek;
  final String namaPetugas;
  final String alamatPetugas;
  final String namaPemilikProyek;
  final String nik;
  final String noHp;
  final String alamat;
  final String signature;
  final String tandaTangan;
  final String nominalDisetujui;
  final String createdAt;

  AgreementLetter({
    required this.idProjek,
    required this.idUser,
    required this.namaProyek,
    required this.namaPetugas,
    required this.alamatPetugas,
    required this.namaPemilikProyek,
    required this.nik,
    required this.noHp,
    required this.alamat,
    required this.signature,
    required this.tandaTangan,
    required this.nominalDisetujui,
    required this.createdAt,
  });

  factory AgreementLetter.fromJson(Map<String, dynamic> json) {
    return AgreementLetter(
      idProjek: json['idProjek'] ?? '',
      idUser: json['idUser'] ?? '',
      namaProyek: json['namaProyek'] ?? '',
      namaPetugas: json['namaPetugas'] ?? '',
      alamatPetugas: json['alamatPetugas'] ?? '',
      namaPemilikProyek: json['namaPemilikProyek'] ?? '',
      nik: json['nik'] ?? '',
      noHp: json['noHp'] ?? '',
      alamat: json['alamat'] ?? '',
      signature: json['signature'] ?? '',
      tandaTangan: json['tandaTangan'] ?? '',
      nominalDisetujui: json['nominalDisetujui'] ?? '0',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProjek': idProjek,
      'idUser': idUser,
      'namaProyek': namaProyek,
      'namaPetugas': namaPetugas,
      'alamatPetugas': alamatPetugas,
      'namaPemilikProyek': namaPemilikProyek,
      'nik': nik,
      'noHp': noHp,
      'alamat': alamat,
      'signature': signature,
      'tandaTangan': tandaTangan,
      'nominalDisetujui': nominalDisetujui,
      'createdAt': createdAt,
    };
  }
}