import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

Widget cardLoginRegisWidget({required String title,required String subtitle,required double deviceWidth}) {
  return Container(
    width: deviceWidth,
    color: lightGreen,
    padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset("assets/images/logo-koperasi.png"),
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: grayFont,
          ),
        ),
      ],
    ),
  );
}
