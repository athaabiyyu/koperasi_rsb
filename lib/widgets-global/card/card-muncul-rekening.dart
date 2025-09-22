import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';

class CardPembayaranBank extends StatelessWidget {
  final String bankName;
  final String bankLogo;
  final String noRekening;
  final String namaPemilik;
  final String totalPembayaran;
  final VoidCallback? onCopy;
  final VoidCallback? onKonfirmasi;

  const CardPembayaranBank({
    super.key,
    required this.bankName,
    required this.bankLogo,
    required this.noRekening,
    required this.namaPemilik,
    required this.totalPembayaran,
    this.onCopy,
    this.onKonfirmasi,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Text(
              "Transfer Bank",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(
              width: double.infinity,
              child: Divider(
                color: secGrayFont,
                thickness: 0.2,
                height: 20,
              ),
            ),

            // Logo + No Rekening
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(bankLogo, width: 50, height: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nomor Rekening",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        noRekening,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        namaPemilik,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Copy
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: noRekening));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nomor rekening disalin")),
                    );
                    if (onCopy != null) onCopy!();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: darkGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.copy, color: darkGreen, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "Copy",
                          style: GoogleFonts.poppins(
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: secGrayFont,
                      thickness: 0.2,
                      height: 20,
                    ),
                  ),

            // Total Pembayaran
            Text(
              "Total Pembayaran",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              totalPembayaran,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: darkGreen,
              ),
            ),

            const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: secGrayFont,
                      thickness: 0.2,
                      height: 20,
                    ),
                  ),

            const SizedBox(height: 20),

            // Tombol Konfirmasi
            Center(
              child: SizedBox(
                width: deviceWidth * 0.75,
                height: 55,
                child: CustomButton(
                  text: "KONFIRMASI PEMBAYARAN",
                  onPressed: onKonfirmasi ?? () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
