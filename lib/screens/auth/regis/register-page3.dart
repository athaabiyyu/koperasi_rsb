import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationPage3 extends StatefulWidget {
  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  late double _deviceWidth;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nikController = TextEditingController();

  // File variables
  File? _fotoDiri;
  File? _fotoKtp;
  bool _isLoading = false;

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }

  // Function untuk handle foto diri picked
  void _handleFotoDiriPicked(dynamic file) {
    if (file != null && file.path != null) {
      setState(() {
        _fotoDiri = File(file.path);
      });
      print('File Foto Diri yang dipilih: ${file.name}');
    }
  }

  // Function untuk handle foto KTP picked
  void _handleFotoKtpPicked(dynamic file) {
    if (file != null && file.path != null) {
      setState(() {
        _fotoKtp = File(file.path);
      });
      print('File KTP yang dipilih: ${file.name}');
    }
  }

  // Validasi form dan tampilkan dialog
  void _onDaftarButtonPressed() {
    if (!_formKey.currentState!.validate()) return;

    // Validasi kedua file harus diupload
    if (_fotoDiri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap upload foto diri'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_fotoKtp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap upload foto KTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simpan NIK dan kedua file ke provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.saveRegistrationStep({
      'nik': _nikController.text.trim(),
      'foto_diri_file': _fotoDiri,
      'foto_ktp_file': _fotoKtp,
    });

    // Tampilkan dialog join penyertaan
    showDialogJoinPenyertaan(
      context: context,
      onJoin: () {
        // User memilih join penyertaan
        print("User joined penyertaan");
        Navigator.of(context).pop(); // Tutup dialog
        
        // Tampilkan detail pembayaran dengan penyertaan
        DetailPembayaranAwalMember.show(
          context,
          alertTitle: "Detail Pembayaran",
          alertMessage: "Pastikan data pembayaran sudah benar.",
          paymentTitle: "Detail Pembayaran",
          paymentHeader: "Informasi Pembayaran",
          paymentItems: [
            PaymentItem(title: "Setoran Awal", price: "Rp 50.000"),
            PaymentItem(
                title: "Simpanan Wajib 1 Tahun Member UMKM",
                price: "Rp 120.000"),
            PaymentItem(
                title: "Simpanan Penyertaan Modal",
                price: "Rp 500.000"),
          ],
          totalPrice: "Rp 670.000",
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog pembayaran
            // Navigate ke payment form dengan penyertaan
            Navigator.pushNamed(context, '/payment-form');
          },
        );
      },
      onCancel: () {
        // User memilih skip penyertaan, tampilkan detail pembayaran
        Navigator.of(context).pop(); // Tutup dialog join penyertaan
        DetailPembayaranAwalMember.show(
          context,
          alertTitle: "Detail Pembayaran",
          alertMessage: "Pastikan data pembayaran sudah benar.",
          paymentTitle: "Detail Pembayaran",
          paymentHeader: "Informasi Pembayaran",
          paymentItems: [
            PaymentItem(title: "Setoran Awal", price: "Rp 50.000"),
            PaymentItem(
                title: "Simpanan Wajib 1 Tahun Member UMKM",
                price: "Rp 120.000"),
          ],
          totalPrice: "Rp 170.000",
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog pembayaran
            // Navigate ke payment form tanpa penyertaan
            Navigator.pushNamed(context, '/payment-form');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: cardLoginRegisWidget(
                  title: "Lengkapi Data!",
                  subtitle:
                      "Silahkan lengkapi formulir ini untuk verivikasi akun anda",
                  deviceWidth: _deviceWidth,
                ),
              ),

              // Form section
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.07),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      CustomTextFormField(
                        controller: _nikController,
                        label: "NIK",
                        hint: "Nomor Induk Anda",
                        keyboardType: TextInputType.number,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIK wajib diisi";
                          } else if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                            return "NIK harus 16 digit angka";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Upload Foto Diri
                      FileUploadForm(
                        label: 'Foto Diri',
                        descriptions: const [
                          '• Upload foto diri (selfie)',
                          '• Pastikan wajah terlihat jelas',
                          '• Maksimum size file 10 MB',
                        ],
                        maxFileSizeMB: 10,
                        onFilePicked: _handleFotoDiriPicked,
                      ),

                      const SizedBox(height: 30),

                      // Upload Foto KTP
                      FileUploadForm(
                        label: 'Foto KTP',
                        descriptions: const [
                          '• Upload foto KTP',
                          '• Pastikan data KTP terlihat jelas',
                          '• Maksimum size file 10 MB',
                        ],
                        maxFileSizeMB: 10,
                        onFilePicked: _handleFotoKtpPicked,
                      ),

                      const SizedBox(height: 40),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                                text:
                                    'Dengan mengklik tombol "Daftar" anda setuju dengan '),
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: darkGreen,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to terms page
                                },
                            ),
                            const TextSpan(text: ' serta '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: darkGreen,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to privacy policy page
                                },
                            ),
                            const TextSpan(text: ' kami.'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: darkGreen,
                                ),
                              )
                            : CustomButton(
                                text: "DAFTAR",
                                onPressed: _onDaftarButtonPressed,
                              ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _isLoading ? Colors.grey : darkGreen,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    _isLoading ? Colors.grey : darkGreen,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}