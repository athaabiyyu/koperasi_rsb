import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/form/konfirmasiPembayaran-Form.dart';
import 'package:koperasi_rsb/widgets-global/template-page/pembayaran-section.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  @override
  State<KonfirmasiPembayaran> createState() => _KonfirmasiPembayaranState();
}

class _KonfirmasiPembayaranState extends State<KonfirmasiPembayaran> {
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
                  alertMessage:
                      "Isi data nama, nomor rekening, dan bank, lalu unggah bukti pembayaran Anda.",
                ),

                // Card rekening bank
                KonfirmasiPembayaranForm(
                  onSubmit: (data) {
                    print(data);
                    // lakukan request API di sini
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
