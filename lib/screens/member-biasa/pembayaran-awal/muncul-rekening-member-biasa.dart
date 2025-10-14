import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/konfirmasi-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';
import 'package:koperasi_rsb/widgets-global/form/form-konfirmasi-pembayaran.dart';

class MunculRekeningMemberBiasa extends StatefulWidget {
  @override
  State<MunculRekeningMemberBiasa> createState() =>
      _MunculRekeningMemberBiasaState();
}

class _MunculRekeningMemberBiasaState extends State<MunculRekeningMemberBiasa> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

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
                  alertMessage:
                      "•   Selesaikan pembayaran di nomor rekening kami.\n"
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
                    // Logika copy rekening + snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor rekening berhasil disalin'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onKonfirmasi: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KonfirmasiPembayaran(), // langsung aja
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
