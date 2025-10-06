import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionTable extends StatelessWidget {
  final String status;
  final List<Map<String, String>> data;

  const TransactionTable({
    super.key,
    required this.status,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Filter data yang valid (tidak kosong)
    final validData = data.where((item) => item.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header tabel - selalu ditampilkan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Tanggal',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Metode Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Nominal',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        // Data rows dengan scroll
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: validData.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada data',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: validData.length,
                    itemBuilder: (context, index) {
                      final tx = validData[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                tx['tanggal'] ?? '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                tx['metode'] ?? '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                tx['nominal'] ?? '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}