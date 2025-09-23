import 'package:flutter/material.dart';
import 'package:koperasi_rsb/login/view/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/member-biasa/view/pembayaran-awal/muncul-rekening.dart';
import 'package:koperasi_rsb/member-premium/view/pembayaran-awal/pilih-nomimal-pembayaran.dart';
import 'package:koperasi_rsb/regis/view/register-page1.dart';
import 'package:koperasi_rsb/regis/view/register-page2.dart';
import 'package:koperasi_rsb/regis/view/register-page3.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/member-biasa/view/pembayaran-awal/detail-pembayaran-biasa.dart';
import 'package:koperasi_rsb/member-biasa/view/pembayaran-awal/konfirmasi-pembayaran.dart';
import 'package:koperasi_rsb/member-premium/view/pembayaran-awal/pilih-nomimal-pembayaran.dart';


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
      home: PilihNominalPembayaran(),
    );
  }
}
