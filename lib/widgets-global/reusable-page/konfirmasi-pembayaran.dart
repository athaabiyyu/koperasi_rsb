import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/form-konfirmasi-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  @override
  State<KonfirmasiPembayaran> createState() => _KonfirmasiPembayaranState();
}

class _KonfirmasiPembayaranState extends State<KonfirmasiPembayaran> {
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
                  alertMessage:
                      "Isi data nama, nomor rekening, dan bank, lalu unggah bukti pembayaran Anda.",
                ),

                // Card rekening bank
                KonfirmasiPembayaran(
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}