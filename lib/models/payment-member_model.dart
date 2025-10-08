import 'dart:io';

class PaymentModel {
  final String namaBank;
  final String noRekening;
  final String namaPemilikRekening;
  final File buktiPembayaran;

  PaymentModel({
    required this.namaBank,
    required this.noRekening,
    required this.namaPemilikRekening,
    required this.buktiPembayaran,
  });

  // Validate all required fields
  bool isValid() {
    return namaBank.isNotEmpty &&
        noRekening.isNotEmpty &&
        namaPemilikRekening.isNotEmpty;
  }

  // Convert to map for API
  Map<String, String> toMap() {
    return {
      'nama_bank': namaBank.trim(),
      'no_rekening': noRekening.trim(),
      'nama_pemilik_rekening': namaPemilikRekening.trim(),
    };
  }

  @override
  String toString() {
    return 'PaymentModel(namaBank: $namaBank, noRekening: $noRekening, namaPemilikRekening: $namaPemilikRekening)';
  }
}