import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/screens/otp/verify_otp.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceWidth;
  late double _deviceHeight;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load saved credentials
  Future<void> _loadSavedCredentials() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final credentials = await authProvider.getSavedCredentials();

    if (credentials['no_hp'] != null && credentials['password'] != null) {
      setState(() {
        // Remove '62' prefix jika ada untuk display di UI
        String phoneNumber = credentials['no_hp']!;
        if (phoneNumber.startsWith('62')) {
          phoneNumber = phoneNumber.substring(2);
        }
        _phoneController.text = phoneNumber;
        _passwordController.text = credentials['password']!;
        _rememberMe = credentials['remember_me'] == 'true';
      });

      print('Credentials loaded from storage');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final noHp = "62${_phoneController.text.trim()}";
      final password = _passwordController.text.trim();

      // Pass rememberMe ke login method
      final success =
          await authProvider.login(noHp, password, rememberMe: _rememberMe);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        final userStatus = authProvider.userStatus;

        switch (userStatus) {
          case 'OTP TERKIRIM':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Silakan masukkan kode OTP yang telah dikirim ke WhatsApp Anda'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 3),
              ),
            );

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Akun Anda sedang diverifikasi oleh Admin. Tunggu hingga 2x24 jam.\n\nSetelah disetujui, Anda akan menerima kode OTP via WhatsApp.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 6),
              ),
            );
            await authProvider.logout(keepCredentials: _rememberMe);
            break;

          case 'DITOLAK':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Pendaftaran Anda ditolak oleh Admin. Silakan hubungi admin untuk informasi lebih lanjut.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
            await authProvider.logout(keepCredentials: _rememberMe);
            break;

          case 'AKTIF':
            // Fetch user profile sebelum navigate ke dashboard
            if (authProvider.userId != null && authProvider.token != null) {
              try {
                await userProvider.fetchUserProfile(
                  userId: authProvider.userId!,
                  token: authProvider.token!,
                );
                print('✅ User profile fetched successfully after login');
              } catch (e) {
                print('⚠️ Warning: Failed to fetch user profile: $e');
              }
            }

            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4CAF50),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Login berhasil!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat datang di Koperasi RSB.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop();
              
              // Navigate berdasarkan role
              final userRole = authProvider.userRole;
              if (userRole == 'PLATINUM') {
                Navigator.pushReplacementNamed(context, '/member-platinum');
              } else {
                Navigator.pushReplacementNamed(context, '/member-reguler');
              }
            });
            break;

          case 'TIDAK AKTIF':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Akun Anda tidak aktif. Silakan hubungi admin untuk mengaktifkan kembali.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
            await authProvider.logout(keepCredentials: _rememberMe);
            break;

          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Status akun: ${userStatus ?? "Tidak diketahui"}'),
                backgroundColor: Colors.grey,
                duration: const Duration(seconds: 3),
              ),
            );
            await authProvider.logout(keepCredentials: _rememberMe);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ??
                  'Login gagal. Periksa nomor HP dan password Anda.',
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
    _deviceHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: lightGreen,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _deviceHeight * 0.27,
                child: cardLoginRegisWidget(
                  title: "Selamat Datang!",
                  subtitle: "Silahkan masuk untuk melanjutkan",
                  deviceWidth: _deviceWidth,
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.07),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        PhoneNumberField(
                          controller: _phoneController,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nomor wajib diisi";
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: _isLoading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                activeColor: darkGreen,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _rememberMe = !_rememberMe;
                                        });
                                      },
                                child: Text(
                                  'Ingat Saya',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _isLoading
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: _deviceWidth * 0.75,
                          height: 55,
                          child: _isLoading
                              ? const Center(
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
                                      Navigator.pushNamed(
                                          context, '/registration1');
                                    },
                              child: Text(
                                'Daftar',
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
                      ],
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