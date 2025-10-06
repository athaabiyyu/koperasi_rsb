import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

Future<void> showTopUpSimpananWajibDialog({
  required BuildContext context,
  required String namaAnggota,
  required String tagihan,
  required String nominalTagihan,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header dengan close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Up Saldo Simpanan Wajib",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Data rows dengan input parameter
            _buildDataRow("Nama Anggota", namaAnggota),
            const SizedBox(height: 20),
            _buildDataRow("Tagihan", tagihan),
            const SizedBox(height: 20),
            _buildDataRow("Nominal Tagihan", nominalTagihan),
            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Batal",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // Lanjut ke proses pembayaran
                        print("Lanjut pembayaran: $namaAnggota - $nominalTagihan");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Selanjutnya",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDataRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
