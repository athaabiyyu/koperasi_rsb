  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
  import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
  import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
  import 'package:koperasi_rsb/widgets-global/colors.dart';
  import 'package:koperasi_rsb/providers/auth_provider.dart';
  import 'package:koperasi_rsb/otp/verify_otp.dart';
  import 'package:provider/provider.dart';

  class LoginPage extends StatefulWidget {
    const LoginPage({Key? key}) : super(key: key);

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    late double _deviceWidth;
    final _formKey = GlobalKey<FormState>();

    // Controllers
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    bool _isLoading = false;

    @override
    void dispose() {
      _phoneController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

    Future<void> _handleLogin() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        final noHp = _phoneController.text.trim();
        final password = _passwordController.text.trim();
        
        final success = await authProvider.login(noHp, password);

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (success) {
          // Get user status from provider
          final userStatus = authProvider.userStatus;
          
          print('=== LOGIN SUCCESS ===');
          print('User Status: $userStatus');
          print('====================');

          // Handle based on status
          switch (userStatus) {
            case 'OTP TERKIRIM':
              // User sudah diapprove admin, perlu verifikasi OTP
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Silakan masukkan kode OTP yang telah dikirim ke WhatsApp Anda'),
                  backgroundColor: Colors.blue,
                  duration: Duration(seconds: 3),
                ),
              );
              
              // Navigate to OTP verification page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationPage(
                    noHp: noHp,
                    password: password,
                  ),
                ),
              );
              break;

            case 'MENUNGGU KONFIRMASI':
              // User sudah register tapi belum diapprove admin
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Akun Anda sedang diverifikasi oleh Admin. Tunggu hingga 2x24 jam.\n\nSetelah disetujui, Anda akan menerima kode OTP via WhatsApp.',
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 6),
                ),
              );
              // Logout karena belum bisa akses
              await authProvider.logout();
              break;

            case 'DITOLAK':
              // User ditolak oleh admin
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Pendaftaran Anda ditolak oleh Admin. Silakan hubungi admin untuk informasi lebih lanjut.',
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
              await authProvider.logout();
              break;

            case 'AKTIF':
              // User sudah aktif, bisa masuk
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login berhasil! Selamat datang.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              
              // Navigate to home
              Navigator.pushReplacementNamed(context, '/home');
              break;

            case 'TIDAK AKTIF':
              // User dinonaktifkan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Akun Anda tidak aktif. Silakan hubungi admin untuk mengaktifkan kembali.',
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
              await authProvider.logout();
              break;

            default:
              // Status tidak dikenali
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status akun: ${userStatus ?? "Tidak diketahui"}'),
                  backgroundColor: Colors.grey,
                  duration: const Duration(seconds: 3),
                ),
              );
              await authProvider.logout();
          }
        } else {
          // Login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authProvider.errorMessage ?? 'Login gagal. Periksa nomor HP dan password Anda.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
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
                    title: "Selamat Datang!",
                    subtitle: "Silahkan masuk untuk melanjutkan",
                    deviceWidth: _deviceWidth,
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.07),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        CustomTextFormField(
                          controller: _phoneController,
                          label: "No. Handphone",
                          hint: "081 xxx-xxxx-xxxx",
                          keyboardType: TextInputType.phone,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nomor wajib diisi";
                            } else if (!value.startsWith("08") && !value.startsWith("62")) {
                              return "Format nomor tidak valid";
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
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password wajib diisi";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 50),

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
                                  text: "MASUK",
                                  onPressed: _handleLogin,
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
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(context, '/registration1');
                                    },
                              child: Text(
                                'Daftar',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _isLoading ? Colors.grey : darkGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _isLoading ? Colors.grey : darkGreen,
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