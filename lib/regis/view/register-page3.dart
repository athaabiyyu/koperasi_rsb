import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/template-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class RegisterScreen3 extends StatefulWidget {
  @override
  State<RegisterScreen3> createState() => _RegisterScreen3State();
}

class _RegisterScreen3State extends State<RegisterScreen3> {
  late double _deviceHeight;
  late double _deviceWidth;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
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
                        label: "NIK",
                        hint: "Nomor Induk Anda",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIK wajib diisi";
                          } else if (!value.contains(RegExp(r'^[0-9]{16}$'))) {
                            return "Format tidak valid";
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 30),

                      FileUploadForm(
                        label: 'Dokumen Pendukung',
                        descriptions: const [
                          '• Upload foto KTP',
                          '• Maksimum size file 10 MB',
                        ],
                        maxFileSizeMB: 10,
                        onFilePicked: (file) {
                          print('File yang dipilih: ${file?.name}');
                        },
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
                                    'Dengan mengklik tombol “Daftar” anda setuju dengan '),
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
                                ..onTap = () {},
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
                                ..onTap = () {},
                            ),
                            const TextSpan(text: ' kami.'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: CustomButton(
                          text: "DAFTAR",
                          onPressed: () {
                            showDialogJoinPenyertaan(
                              context: context,
                              onJoin: () {
                                print("User joined penyertaan");
                              },
                              onCancel: () {
                                print("User canceled joined penyertaan");
                              },
                            );
                          },
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
                            onTap: () {},
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: darkGreen,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: darkGreen,
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
