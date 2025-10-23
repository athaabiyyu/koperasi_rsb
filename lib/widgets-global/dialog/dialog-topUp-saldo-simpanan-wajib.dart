import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/form/muncul-rekening-member-biasa.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

void _handlePayment(BuildContext context) {
    // Tutup dialog terlebih dahulu (jika ada)
    Navigator.of(context).pop();
    // Navigate ke halaman MunculRekeningMemberBiasa
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MunculRekeningMemberBiasa(),
      ),
    );
  }

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ===== HEADER =====
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// judul bisa wrap ke bawah
                      Expanded(
                        child: Text(
                          "Top Up Saldo Simpanan Wajib",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          softWrap: true, // penting: biar bisa turun baris
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

                  /// ===== DATA ROWS =====
                  _buildDataRow("Nama Anggota", namaAnggota),
                  const SizedBox(height: 20),
                  _buildDataRow("Tagihan", tagihan),
                  const SizedBox(height: 20),
                  _buildDataRow("Nominal Tagihan", nominalTagihan),
                  const SizedBox(height: 30),

                  /// ===== BUTTONS =====
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
                            onPressed: () => _handlePayment(context),
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
          );
        },
      ),
    ),
  );
}

Widget _buildDataRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        flex: 3,
        child: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
          softWrap: true, // biar teks panjang juga bisa turun
        ),
      ),
    ],
  );
}
