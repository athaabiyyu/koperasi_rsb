import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationPage1 extends StatefulWidget {
  @override
  State<RegistrationPage1> createState() => _RegistrationPage1State();
}

class _RegistrationPage1State extends State<RegistrationPage1> {
  late double _deviceWidth;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function untuk handle next
  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    // Validasi password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi password tidak sama'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simpan data ke provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.saveRegistrationStep({
      'nama': _namaController.text.trim(),
      'no_hp': _phoneController.text.trim(),
      'password': _passwordController.text,
    });

    // Navigate ke page 2
    Navigator.pushNamed(context, '/registration2');
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
                        controller: _namaController,
                        label: "Nama (Sesuai KTP)",
                        hint: "Nama Anda",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama wajib diisi";
                          } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Nama hanya boleh berisi huruf";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      CustomTextFormField(
                        controller: _phoneController,
                        label: "No. Handphone",
                        hint: "081 xxx-xxxx-xxxx",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor wajib diisi";
                          } else if (!value.startsWith("08") && !value.startsWith("62")) {
                            return "Format nomor tidak valid";
                          } else if (value.length < 10) {
                            return "Nomor terlalu pendek";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      CustomTextFormField(
                        controller: _passwordController,
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
                        controller: _confirmPasswordController,
                        label: "Konfirmasi Kata Sandi",
                        hint: "Kata Sandi",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Konfirmasi password wajib diisi";
                          } else if (value.length < 6) {
                            return "Password minimal 6 karakter";
                          } else if (value != _passwordController.text) {
                            return "Password tidak sama";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 50),

                      SizedBox(
                        width: _deviceWidth * 0.75,
                        height: 55,
                        child: CustomButton(
                          text: "SELANJUTNYA",
                          onPressed: _handleNext,
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