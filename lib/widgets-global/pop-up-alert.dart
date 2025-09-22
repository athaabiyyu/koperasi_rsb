import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopUpAlert extends StatelessWidget {
  final String? title; // optional
  final String message;
  final VoidCallback? onClose;

  const PopUpAlert({
    Key? key,
    this.title, // nullable
    required this.message,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Warning triangle icon
    Container(
      width: 40,
      height: 40,
      child: Center(
        child: Image.asset(
          "assets/icons/warning-icon.png",
          fit: BoxFit.contain,
        ),
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          if (title != null) const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  ],
),

    );
  }

  // Static method untuk menampilkan popup sebagai overlay
  static void show(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: PopUpAlert(
            title: title,
            message: message,
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }
}
