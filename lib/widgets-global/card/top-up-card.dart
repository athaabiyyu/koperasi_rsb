import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TopUpCard extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback? onPressed;

  const TopUpCard({
    super.key,
    required this.title,
    required this.amount,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/icons/nb-saldo-icon.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/coin-icon.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    amount,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (onPressed != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Top Up",
                  onPressed: onPressed!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}