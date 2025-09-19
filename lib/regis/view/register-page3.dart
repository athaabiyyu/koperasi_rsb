import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card-login-regis.dart';
import 'package:koperasi_rsb/widgets-global/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/green-button.dart';
import 'package:koperasi_rsb/widgets-global/dateFormField.dart';
import 'package:koperasi_rsb/widgets-global/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialogJoinPenyertaan.dart';

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
                height: _deviceHeight * 0.25,
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
                      const SizedBox(height: 50),
                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: CustomButton(
                          text: "Daftar",
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
                          const Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Masuk',
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
