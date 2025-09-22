import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/pop-up-alert.dart';

class MunculRekening extends StatefulWidget {
  @override
  State<MunculRekening> createState() => _MunculRekeningState();
}

class _MunculRekeningState extends State<MunculRekening> {
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
                // Gambar ilustrasi
                Image.asset(
                  'assets/images/ava-payment.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                // Text instruksi
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
                  child: Text(
                    "Silahkan transfer ke nomor rekening berikut agar transaksi anda dapat segera kami proses",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Box alert
                const PopUpAlert(
                  title: "Informasi Penting",
                  message: "•   Selesaikan pembayaran di nomor rekening kami.\n"
                      "•   Mohon transfer sesuai jumlah hingga 3 digit terakhir.",
                ),

                const SizedBox(height: 20),

                // Card rekening bank
                CardPembayaranBank(
                  bankName: "BRI",
                  bankLogo: "assets/logo/bri-logo.png",
                  noRekening: "372 178 5022",
                  namaPemilik: "Koperasi Produksi Rejeki Sukses Berkah",
                  totalPembayaran: "Rp 170.000",
                  onCopy: () {
                    // logika copy rekening
                  },
                  onKonfirmasi: () {
                    // aksi konfirmasi pembayaran
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
