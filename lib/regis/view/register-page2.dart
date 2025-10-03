import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/form/dateFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';

class RegistrationPage2 extends StatefulWidget {
  const RegistrationPage2({super.key});

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  late double _deviceWidth;

  final _formKey = GlobalKey<FormState>();

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

                      Row(
                        children: [
                          // Tempat Lahir (60%)
                          Expanded(
                            flex: 5,
                            child: CustomTextFormField(
                              label: "Tempat Lahir",
                              hint: "Tempat Lahir Anda",
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tempat lahir wajib diisi";
                                } else if (!value.contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                                  return "Format tidak valid";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 16),
                          Expanded(
                            flex: 5,
                            child: CustomDateFormField(
                              label: "Tanggal Lahir",
                              hint: "Pilih tanggal lahir",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tanggal lahir wajib diisi";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      CustomDropdownFormField(
                        label: "Provinsi",
                        hint: "Pilih Provinsi",
                        items: ["Jawa Timur", "Jawa Tengah", "Jawa Barat"],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harus dipilih";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          print("Dipilih: $value");
                        },
                      ),

                      const SizedBox(height: 30),

                      CustomDropdownFormField(
                        label: "Kota",
                        hint: "Pilih Kota",
                        items: ["Batu", "Malang", "Surabaya"],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harus dipilih";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          print("Dipilih: $value");
                        },
                      ),

                      const SizedBox(height: 30),

                      CustomDropdownFormField(
                        label: "Kecamatan",
                        hint: "Pilih Kecamatan",
                        items: ["Blimbing", "Klojen", "Lowokwaru"],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harus dipilih";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          print("Dipilih: $value");
                        },
                      ),

                      const SizedBox(height: 30),

                      CustomTextFormField(
                        label: "Detail Alamat",
                        hint: "Cth. Jl. Abdul Gani Atas No. 23",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Detail alamat wajib diisi";
                          } else if (!value
                              .contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                            return "Format tidak valid";
                          }
                          return null;
                        },
                        maxLines: 2,
                      ),

                      const SizedBox(height: 50),

                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: CustomButton(
                          text: "SELANJUTNYA",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamed(context, '/registration3');
                            }
                          },
                        ),
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
