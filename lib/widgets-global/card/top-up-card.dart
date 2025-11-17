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

  bool get hasButton {
    return (widget.title == "Saldo Top Up" && widget.isPlatinum) ||
           widget.title == "Simpanan Wajib";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: hasButton 
              ? MainAxisAlignment.start 
              : MainAxisAlignment.center, 
          children: [
            // ===== TITLE =====
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
              children: [
                Image.asset('assets/icons/coin-icon.png',
                    width: 45, height: 45),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.amount,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),
            
            if (widget.title == "Saldo Top Up" && widget.isPlatinum) ...[
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
            ]

            else if (widget.title == "Simpanan Wajib") ...[
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Top Up",
                  onPressed: widget.onPressed!,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
