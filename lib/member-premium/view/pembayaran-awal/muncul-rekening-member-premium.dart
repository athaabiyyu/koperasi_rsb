import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

class MunculRekeningMemberPremium extends StatefulWidget {
  @override
  State<MunculRekeningMemberPremium> createState() => _MunculRekeningMemberPremiumState();
}

class _MunculRekeningMemberPremiumState extends State<MunculRekeningMemberPremium> {

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
                  totalPembayaran: "Rp 670.000",
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
