import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/dialog/pop-up-alert.dart';

class PembayaranSection extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final String? alertTitle;
  final String? alertMessage;

  const PembayaranSection({
    Key? key,
    this.imagePath,
    this.text,
    this.alertTitle,
    this.alertMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Gambar
        if (imagePath != null) ...[
          Image.asset(
            imagePath!,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
        ],

        // Teks
        if (text != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Popup Alert
        if (alertMessage != null) ...[
          PopUpAlert(
            title:
                alertTitle,
            message: alertMessage!,
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
