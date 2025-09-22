import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/dialog/pop-up-alert.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';

class DetailPembayaranBiasa extends StatelessWidget {
  const DetailPembayaranBiasa({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero, // biar full width
      backgroundColor: Colors.transparent, // biar cuma nampilin child
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bagian atas (PopUpAlert)
            const PopUpAlert(
              message:
                  "Lakukan pembayaran untuk menyelesaikan pendaftaran Anda sebagai anggota koperasi.",
            ),

            // Spacer otomatis (jadi card selalu nempel bawah)
            const Spacer(),

            // Bagian bawah (CardDetailPembayaran)
            CardDetailPembayaran(
              title: "Detail Pembayaran Setoran Awal",
              headerText: "Informasi Pembayaran",
              items: [
                PaymentItem(title: "Simpanan Pokok", price: "Rp. 50.000"),
                PaymentItem(
                    title: "Simpanan Wajib 1 Tahun Member UMKM",
                    price: "Rp. 120.000"),
              ],
              totalPrice: "Rp. 170.000",
              onPressed: () {
                // aksi lanjut
              },
            ),
          ],
        ),
      ),
    );
  }
}
