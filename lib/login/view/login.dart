import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceWidth;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, 
          child: Column(
            children: [
              // Card hijau di atas
              cardLoginRegisWidget(
                title: "Selamat Datang!",
                subtitle: "Silahkan masuk untuk melanjutkan",
                deviceWidth: _deviceWidth,
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.07),
                  child: SingleChildScrollView(
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
                                  // TODO: navigasi ke home/dashboard
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
                                onTap: () {
                                  Navigator.pushNamed(context, '/registration1');
                                },
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
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
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
