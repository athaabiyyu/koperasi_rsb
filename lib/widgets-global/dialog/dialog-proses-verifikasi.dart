import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  String? title,
  String? description,
  String? imagePath,
  String? buttonText,
  VoidCallback? onButtonPressed,
  String? bottomText,
  VoidCallback? onBottomTextTap,
  bool showOtpFields = false,
  int otpLength = 4,
  bool dismissible = true,
}) {
  final List<TextEditingController> otpControllers =
      List.generate(otpLength, (_) => TextEditingController());

  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            if (title != null) ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Image
            if (imagePath != null) ...[
              Image.asset(
                imagePath,
                height: 120,
              ),
              const SizedBox(height: 16),
            ],

            // Description
            if (description != null) ...[
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: grayFont,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // OTP Fields
            if (showOtpFields)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  otpLength,
                  (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < otpLength - 1) {
                          FocusScope.of(ctx).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            if (showOtpFields) const SizedBox(height: 20),

            // Main Button
            if (buttonText != null) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: CustomButton(
                  text: buttonText,
                  onPressed: () {
                    if (onButtonPressed != null) {
                      if (showOtpFields) {
                        final otpCode =
                            otpControllers.map((c) => c.text).join();
                        print("OTP Code: $otpCode");
                      }
                      onButtonPressed();
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Bottom Text
            if (bottomText != null) ...[
              GestureDetector(
                onTap: onBottomTextTap,
                child: Text(
                  bottomText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
