import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card-login-regis.dart';
import 'package:koperasi_rsb/widgets-global/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/green-button.dart';

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
                height: _deviceHeight * 0.25,
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
                      const SizedBox(height: 35),
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
                          text: "Masuk",
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
                          const Text(
                            'Belum punya akun? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Daftar disini',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green, // warna hijau
                                decoration:
                                    TextDecoration.underline, // garis bawah
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
