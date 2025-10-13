import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

Widget cardLoginRegisWidget({
  required String title,
  required String subtitle,
  required double deviceWidth,
}) {
  return Container(
    width: deviceWidth,
    color: lightGreen,
    padding: EdgeInsets.symmetric(
      horizontal: deviceWidth * 0.07,
      vertical: 24,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/logo-koperasi.png",
          height: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: grayFont,
          ),
          softWrap: true,
        ),
      ],
    ),
  );
}
