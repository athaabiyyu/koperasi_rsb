import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/login/view/login.dart';
import 'package:koperasi_rsb/regis/view/register-page1.dart';
import 'package:koperasi_rsb/regis/view/register-page2.dart';
import 'package:koperasi_rsb/regis/view/register-page3.dart';
import 'package:koperasi_rsb/splash_screen.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: lightGreen),
        useMaterial3: true,
         textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => LoginPage(),
        '/registration1' : (context) => RegistrationPage1(),
        '/registration2' : (context) => RegistrationPage2(),
        '/registration3' : (context) => RegistrationPage3(),
      },
    );
  }
}
