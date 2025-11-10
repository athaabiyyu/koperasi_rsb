import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TopUpCard extends StatefulWidget {
  final String title;
  final String amount;
  final VoidCallback? onPressed;
  final bool isPlatinum;

  const TopUpCard({
    super.key,
    required this.title,
    required this.amount,
    this.onPressed,
    this.isPlatinum = false,
  });

  @override
  State<TopUpCard> createState() => _TopUpCardState();
}

class _TopUpCardState extends State<TopUpCard> {
  bool _showWithdrawButton = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/icons/nb-saldo-icon.png',
                  width: 22,
                  height: 22,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/coin-icon.png',
                  width: 45,
                  height: 45,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.amount,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (widget.onPressed != null) ...[
              const SizedBox(height: 12),
              // Jika belum show withdraw button, tampilkan satu button dengan icon dropdown
              if (!_showWithdrawButton) ...[
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Top Up",
                    onPressed: widget.isPlatinum
                        ? () {
                            setState(() {
                              _showWithdrawButton = true;
                            });
                          }
                        : widget.onPressed!,
                  ),
                ),
              ] else ...[
                // Tampilkan kedua button
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Top Up",
                        onPressed: widget.onPressed!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement tarik saldo logic
                          Navigator.pushNamed(context, '/withdraw-saldo');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(color: darkGreen, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Tarik Saldo",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: darkGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Button untuk collapse kembali
                const SizedBox(height: 4),
                Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showWithdrawButton = false;
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: darkGreen,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}