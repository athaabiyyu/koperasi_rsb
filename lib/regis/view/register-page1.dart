import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/template-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';

class RegisterScreen1 extends StatefulWidget {
  @override
  State<RegisterScreen1> createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
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
                  title: "Buat Akun",
                  subtitle: "Silahkan mengisi formulir ini untuk buat akun anda",
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
                        label: "Nama (Sesuai KTP)",
                        hint: "Nama Anda",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama wajib diisi";
                          } else if (!value.contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                            return "Format nomor tidak valid";
                          }
                          return null;
                        },
                      ),

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

                      const SizedBox(height: 30),

                      CustomTextFormField(
                        label: "Konfirmasi Kata Sandi",
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
                          text: "SELANJUTNYAA",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Form valid, lanjut login");
                            }
                          },
                        ),
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
