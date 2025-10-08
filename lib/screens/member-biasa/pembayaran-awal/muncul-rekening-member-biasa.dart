import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';
import 'package:koperasi_rsb/widgets-global/form/form-konfirmasi-pembayaran.dart';

class MunculRekeningMemberBiasa extends StatefulWidget {
  @override
  State<MunculRekeningMemberBiasa> createState() => _MunculRekeningMemberBiasaState();
}

class _MunculRekeningMemberBiasaState extends State<MunculRekeningMemberBiasa> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PembayaranSection(
                  imagePath: 'assets/images/ava-payment.png',
                  text:
                      "Silahkan transfer ke nomor rekening berikut agar transaksi anda dapat segera kami proses",
                  alertTitle: "Informasi Penting !",
                  alertMessage: "•   Selesaikan pembayaran di nomor rekening kami.\n"
                      "•   Mohon transfer sesuai jumlah hingga 3 digit terakhir.",
                ),

                // Card rekening bank
                CardPembayaranBank(
                  bankName: "BRI",
                  bankLogo: "assets/logo/bri-logo.png",
                  noRekening: "372 178 5022",
                  namaPemilik: "Koperasi Produksi Rejeki Sukses Berkah",
                  totalPembayaran: "Rp 170.000",
                  onCopy: () {
                    // Logika copy rekening
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor rekening berhasil disalin'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onKonfirmasi: () {
                    // Navigasi ke halaman form konfirmasi pembayaran
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          backgroundColor: Colors.grey.shade100,
                          appBar: AppBar(
                            title: const Text('Konfirmasi Pembayaran'),
                            backgroundColor: Colors.white,
                            elevation: 1,
                          ),
                          body: SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: KonfirmasiPembayaranForm(
                                // onSubmit: (data) {
                                //   // Handle submit form
                                //   print('Data konfirmasi pembayaran: $data');
                                  
                                //   // Tampilkan snackbar sukses atau navigasi ke halaman lain
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content: Text('Pembayaran berhasil dikonfirmasi'),
                                //     ),
                                //   );
                                // },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}