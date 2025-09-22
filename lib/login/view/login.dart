import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/template-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  title: "Selamat Datang!",
                  subtitle: "Silahkan masuk untuk melanjutkan",
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
                        label: "No. Handphone",
                        hint: "+62 xxx-xxxx-xxxx",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor wajib diisi";
                          } else if (!value.contains("+62")) {
                            return "Format nomor tidak valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        label: "Kata Sandi",
                        hint: "Kata Sandi",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password wajib diisi";
                          } else if (value.length < 6) {
                            return "Password minimal 6 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: CustomButton(
                          text: "MASUK",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Form valid, lanjut login");
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Daftar disini',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                                decorationColor: darkGreen,
                                decorationThickness: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _deviceHeight),
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
