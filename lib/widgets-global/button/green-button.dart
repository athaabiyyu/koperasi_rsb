import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; 
  final Color color;
  final Color textColor;
  final double radius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = darkGreen,
    this.textColor = Colors.white,
    this.radius = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
