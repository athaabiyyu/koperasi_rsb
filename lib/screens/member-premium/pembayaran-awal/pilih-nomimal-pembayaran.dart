import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

class PilihNominalPembayaran extends StatefulWidget {
  @override
  State<PilihNominalPembayaran> createState() =>
      _PilihNominalPembayaranFormState();
}

class _PilihNominalPembayaranFormState extends State<PilihNominalPembayaran> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
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
                      "Minimal setoran Rp500.000 dan berlaku kelipatan Rp500.000",
                ),
                Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul Card
                            const SizedBox(height: 5),
                            Text(
                              "Pilih Nominal Pembayaran",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              child: Divider(
                                color: secGrayFont,
                                thickness: 0.2,
                                height: 20,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Dropdown Nominal
                            CustomDropdownFormField(
                              label: "Pilih Nominal",
                              hint: "Rp. 500.000",
                              items: const [
                                "RP. 1.000.000",
                                "RP. 1.500.000",
                                "RP. 2.000.000",
                                "Nominal Lainnya"
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Pilih nominal terlebih dahulu";
                                }
                                return null;
                              },
                              onChanged: (String? value) {},
                            ),

                            const SizedBox(height: 30),

                            CustomTextFormField(
                              label: "Masukkan Nominal Lainnya",
                              hint: "RP. 5.000.000",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nominal lainnya wajib diisi";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),

                            // Tombol Konfirmasi
                            Center(
                              child: SizedBox(
                                width: _deviceWidth * 0.75,
                                height: 55,
                                child: CustomButton(
                                  text: "LANJUTKAN PEMBAYARAN",
                                  onPressed: () {
                                    DetailPembayaranAwalMember.show(
                                      context,
                                      alertTitle: "Detail Pembayaran",
                                      alertMessage:
                                          "Pastikan data pembayaran sudah benar.",
                                      paymentTitle: "Detail Pembayaran",
                                      paymentHeader: "Informasi Pembayaran",
                                      paymentItems: [
                                        PaymentItem(
                                            title: "Setoran Awal",
                                            price: "Rp 50.000"),
                                        PaymentItem(
                                            title: "Simpanan Wajib 1 Tahun Member UMKM",
                                            price: "Rp 120.000"),
                                        PaymentItem(
                                            title: "Gabung Penyertaan",
                                            price: "Rp 500.000"),
                                      ],
                                      totalPrice: "Rp 670.000",
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // tutup dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Pembayaran dikonfirmasi")),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
