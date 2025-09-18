import 'package:flutter/material.dart';
import 'package:koperasi_rsb/login/view/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/regis/register-page1.dart';
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
         textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: RegisterScreen1(),
    );
  }
}
