import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

class DialogPilihNominalPembayaran extends StatefulWidget {
  final bool isTopUpOnly;
  final bool isPenyertaan; // ✅ Flag baru untuk penyertaan
  
  const DialogPilihNominalPembayaran({
    super.key,
    this.isTopUpOnly = false,
    this.isPenyertaan = false, // ✅ Default false
  });

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
    print('=== _submit() dipanggil ===');
    print('isTopUpOnly: ${widget.isTopUpOnly}');
    print('isPenyertaan: ${widget.isPenyertaan}');

    if (!_formKey.currentState!.validate()) {
      print('Form tidak valid');
      return;
    }

    print('Form valid, dropdown value: $_dropdownValue');

    // Ambil nominal mentah
    String rawNominal;
    if (_dropdownValue == 'Nominal Lainnya') {
      rawNominal = _nominalLainController.text.trim();
    } else {
      rawNominal = _dropdownValue ?? '';
    }

    print('Raw nominal: $rawNominal');

    // Normalisasi string angka
    final numericString = rawNominal
        .toUpperCase()
        .replaceAll('RP', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .replaceAll(':', '')
        .trim();

    print('Numeric string: $numericString');

    int? nominalInt = int.tryParse(numericString);
    print('Parsed int: $nominalInt');

    if (nominalInt == null || nominalInt <= 0) {
      print('Nominal invalid!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format nominal tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String formattedNominal = _formatRupiah(nominalInt);
    print('Formatted nominal: $formattedNominal');

    // ✅ Hitung total berdasarkan tipe transaksi
    int total;
    if (widget.isPenyertaan) {
      // ✅ Penyertaan (upgrade platinum): hanya nominal penyertaan
      total = nominalInt;
      print('Penyertaan mode - Total: ${_formatRupiah(total)}');
    } else if (widget.isTopUpOnly) {
      // Top-up biasa: hanya nominal top-up
      total = nominalInt;
      print('Top-up only mode - Total: ${_formatRupiah(total)}');
    } else {
      // Registrasi: termasuk setoran awal + simpanan wajib
      final int setoranAwal = 50000;
      final int simpananWajib = 120000;
      total = setoranAwal + simpananWajib + nominalInt;
      print('Registration mode - Total: ${_formatRupiah(total)}');
    }

    // Tutup dialog
    Navigator.of(context).pop();

    // Navigate dengan parameter
    Navigator.pushNamed(
      context,
      '/payment-form',
      arguments: {
        'nominalPenyertaan': nominalInt,
        'totalPembayaran': total,
        'formattedNominal': formattedNominal,
        'isTopUpOnly': widget.isTopUpOnly,
        'isPenyertaan': widget.isPenyertaan, // ✅ Pass flag ke halaman berikutnya
      },
    );
  }

  String _formatRupiah(int value) {
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
    
    // ✅ Sesuaikan pesan alert berdasarkan tipe transaksi
    final alertMessage = widget.isPenyertaan
        ? "Minimal penyertaan Rp500.000 dan berlaku kelipatan Rp500.000"
        : widget.isTopUpOnly
            ? "Minimal top-up Rp500.000 dan berlaku kelipatan Rp500.000"
            : "Minimal setoran Rp500.000 dan berlaku kelipatan Rp500.000";
    
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
                    onPressed: () {
                      print('Close button pressed');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                PembayaranSection(
                  imagePath: 'assets/images/ava-payment.png',
                  alertMessage: alertMessage,
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
                          print('Dropdown changed: $value');
                          setState(() {
                            _dropdownValue = value;
                            if (value != 'Nominal Lainnya') {
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
                                  .toUpperCase()
                                  .replaceAll('RP', '')
                                  .replaceAll('.', '')
                                  .replaceAll(',', '')
                                  .replaceAll(' ', '')
                                  .trim();
                              final intVal = int.tryParse(cleaned);
                              if (intVal == null) {
                                return 'Format tidak valid';
                              }
                              if (intVal < 500000) {
                                return 'Minimal Rp 500.000';
                              }
                              if (intVal <= 2000000) {
                                return 'Harus lebih dari Rp 2.000.000 dan kelipatan Rp 500.000';
                              }
                              if (intVal % 500000 != 0) {
                                return 'Harus kelipatan Rp 500.000';
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
                            onPressed: () {
                              print('Button LANJUTKAN PEMBAYARAN pressed');
                              _submit();
                            },
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

// ✅ Update fungsi show dialog untuk menerima parameter
Future<T?> showDialogPilihNominalPembayaran<T>(
  BuildContext context, {
  bool isTopUpOnly = false,
  bool isPenyertaan = false, // ✅ Parameter baru
}) {
  print('=== showDialogPilihNominalPembayaran called ===');
  print('isTopUpOnly: $isTopUpOnly');
  print('isPenyertaan: $isPenyertaan');
  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    builder: (_) => DialogPilihNominalPembayaran(
      isTopUpOnly: isTopUpOnly,
      isPenyertaan: isPenyertaan, // ✅ Pass parameter
    ),
  );
}