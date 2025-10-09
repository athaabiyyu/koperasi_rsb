import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

/// Dialog versi dari halaman PilihNominalPembayaran tanpa mengubah file aslinya.
class DialogPilihNominalPembayaran extends StatefulWidget {
  const DialogPilihNominalPembayaran({super.key});

  @override
  State<DialogPilihNominalPembayaran> createState() =>
      _DialogPilihNominalPembayaranState();
}

class _DialogPilihNominalPembayaranState
    extends State<DialogPilihNominalPembayaran> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _dropdownValue;
  final TextEditingController _nominalLainController = TextEditingController();

  @override
  void dispose() {
    _nominalLainController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Ambil nominal mentah berdasarkan pilihan
    String rawNominal;
    if (_dropdownValue == 'Nominal Lainnya') {
      rawNominal = _nominalLainController.text.trim();
    } else {
      rawNominal = _dropdownValue ?? '';
    }

    // Normalisasi string angka
    final numericString = rawNominal
        .replaceAll('RP', '')
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .replaceAll(':', '');
    int? nominalInt = int.tryParse(numericString);
    String formattedNominal =
        nominalInt != null ? _formatRupiah(nominalInt) : rawNominal;

    // Hitung total (bisa ditambah item lain jika diperlukan)
    int totalInt = nominalInt ?? 0;
    String totalFormatted = _formatRupiah(totalInt);

    Navigator.of(context).pop(); // Tutup dialog pilih nominal

    DetailPembayaranAwalMember.show(
      context,
      alertTitle: "Detail Pembayaran",
      alertMessage: "Pastikan data pembayaran sudah benar.",
      paymentTitle: "Detail Pembayaran",
      paymentHeader: "Informasi Pembayaran",
      paymentItems: [
        PaymentItem(title: "Gabung Penyertaan", price: formattedNominal),
      ],
      totalPrice: totalFormatted,
      onPressed: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pembayaran dikonfirmasi")),
        );
      },
    );
  }

  String _formatRupiah(int value) {
    // Format sederhana: pisah tiap 3 digit dari belakang
    final chars = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write('.');
      buffer.write(chars[i]);
    }
    return 'Rp ' + buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const PembayaranSection(
                  imagePath: 'assets/images/ava-payment.png',
                  alertMessage:
                      "Minimal setoran Rp500.000 dan berlaku kelipatan Rp500.000",
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      CustomDropdownFormField(
                        label: "Pilih Nominal",
                        hint: "Rp. 500.000",
                        items: const [
                          "RP. 500.000",
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
                        onChanged: (String? value) {
                          setState(() {
                            _dropdownValue = value;
                            if (value == 'Nominal Lainnya') {
                              if (_nominalLainController.text.isEmpty) {
                                
                              }
                            } else {
                              _nominalLainController.clear();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_dropdownValue == 'Nominal Lainnya')
                        CustomTextFormField(
                          label: "Masukkan Nominal Lainnya",
                          hint: "Misal. Rp.5.000.000",
                          controller: _nominalLainController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (_dropdownValue == 'Nominal Lainnya') {
                              if (value == null || value.isEmpty) {
                                return "Nominal lainnya wajib diisi";
                              }
                              final cleaned = value
                                  .replaceAll('.', '')
                                  .replaceAll(',', '')
                                  .replaceAll(' ', '');
                              final intVal = int.tryParse(cleaned);
                              if (intVal == null) {
                                return 'Format tidak valid';
                              }
                              if (intVal <= 2000000) {
                                return 'Harus lebih dari 2.000.000 dan kelipatan 500.000';
                              }
                              if (intVal % 500000 != 0) {
                                return 'Harus kelipatan 500.000';
                              }
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: width * 0.75,
                          height: 50,
                          child: CustomButton(
                            text: "LANJUTKAN PEMBAYARAN",
                            onPressed: _submit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showDialogPilihNominalPembayaran<T>(BuildContext context) {
  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const DialogPilihNominalPembayaran(),
  );
}
