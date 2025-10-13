import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/screens/member-biasa/dompet/dompet.dart';
import 'package:koperasi_rsb/screens/profile/data_diri_page.dart';
import 'package:koperasi_rsb/screens/profile/profile_page.dart';
import 'package:koperasi_rsb/screens/proyek/my_project.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/screens/auth/login/login.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page1.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page2.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page3.dart';
import 'package:koperasi_rsb/otp/verify_otp.dart';
import 'package:koperasi_rsb/splash_screen.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/screens/member-biasa/dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Tambahkan provider lain di sini jika diperlukan
      ],
      child: MaterialApp(
        title: 'Koperasi RSB',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightGreen),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/registration1': (context) => RegistrationPage1(),
          '/registration2': (context) => const RegistrationPage2(),
          '/registration3': (context) => RegistrationPage3(),
          '/dashboard': (context) => const DashboardPage(),
          '/member-reguler': (context) => const DashboardPage(),
          '/my-project' : (context) => const MyProjectPage(),
          '/wallet' : (context) => const DompetPage(),
          '/profile' : (context) => const ProfilePage(),
        },
        // Tambahkan onGenerateRoute untuk handle route dengan parameter
        onGenerateRoute: (settings) {
          // Handle /verify-otp dengan arguments
          if (settings.name == '/verify-otp') {
            final args = settings.arguments as Map<String, dynamic>?;
            
            if (args == null || !args.containsKey('noHp') || !args.containsKey('password')) {
              // Jika arguments tidak valid, redirect ke login
              return MaterialPageRoute(
                builder: (context) => const LoginPage(),
              );
            }
            
            return MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                noHp: args['noHp'] as String,
                password: args['password'] as String,
              ),
            );
          }
          
          // Return null untuk route yang tidak ditemukan
          return null;
        },
      ),
    );
  }
}