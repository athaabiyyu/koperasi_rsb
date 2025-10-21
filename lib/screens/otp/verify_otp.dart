import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/utils/shared_preferences_helper.dart';

class OtpVerificationPage extends StatefulWidget {
  final String noHp;
  final String password;

  const OtpVerificationPage({
    super.key,
    required this.noHp,
    required this.password,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late List<TextEditingController> otpControllers;
  bool _isLoading = false;
  final int otpLength = 4;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    final otpCode = otpControllers.map((c) => c.text).join();
    if (otpCode.length != otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode OTP dengan benar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // STEP 1: Login untuk mendapatkan token
      final loginSuccess = await authProvider.login(widget.noHp, widget.password);

      if (!loginSuccess || authProvider.token == null) {
        setState(() => _isLoading = false);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal login. Silakan periksa nomor HP dan password Anda.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // STEP 2: Verify OTP menggunakan UserProvider
      final result = await userProvider.verifyOtp(
        token: authProvider.token!,
        otp: otpCode,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        // Update user status to AKTIF di AuthProvider
        authProvider.setUserStatus('AKTIF');
        await SharedPreferencesHelper.saveUserStatus('AKTIF');

        // Clear registration data
        authProvider.clearRegistrationData();

        // Fetch user profile setelah OTP berhasil
        if (authProvider.userId != null) {
          await userProvider.fetchUserProfile(
            userId: authProvider.userId!,
            token: authProvider.token!,
          );
        }

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          // Navigate berdasarkan role
          final userRole = authProvider.userRole;
          if (userRole == 'PLATINUM') {
            Navigator.pushReplacementNamed(context, '/member-platinum');
          } else {
            Navigator.pushReplacementNamed(context, '/member-reguler');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Verifikasi OTP gagal'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar
              Image.asset(
                "assets/images/ava-payment.png",
                height: 140,
              ),
              const SizedBox(height: 24),

              // Deskripsi
              Text(
                "Silahkan Masukkan Kode OTP yang telah kami kirim ke nomor ${widget.noHp}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: grayFont,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Input OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  otpLength,
                  (index) => SizedBox(
                    width: 55,
                    child: TextField(
                      controller: otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < otpLength - 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Verifikasi
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.green[700],
                        ),
                      )
                    : CustomButton(
                        text: "Masuk",
                        onPressed: _handleVerifyOtp,
                      ),
              ),
              const SizedBox(height: 16),

              // Teks bawah (Chat Admin)
              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        print("User klik Chat Admin");
                      },
                child: Text(
                  "OTP error atau tidak menerima OTP? Chat Admin",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}