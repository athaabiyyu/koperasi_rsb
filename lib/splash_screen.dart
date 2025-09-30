import 'dart:async';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/login/view/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late double _deviceWidth;

  @override
  void initState() {
    super.initState();

    // set durasi perpindahan layar ke login screen
    Timer(const Duration(seconds: 3), () {

      // navigasi ke login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: const AssetImage("assets/images/logo-koperasi.png"),
          width: _deviceWidth * 2,
        ),
      ),
    );
  }
}
