import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class PenarikanSaldoTable extends StatelessWidget {
  final String status;
  final List<Map<String, String>> data;

  const PenarikanSaldoTable({
    super.key,
    required this.status,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final validData = data.where((item) => item.isNotEmpty).toList();

    return Container(
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                _buildHeader('Tanggal'),
                _buildHeader('Nama Bank', center: true),
                _buildHeader('Jenis Transaksi', center: true),
                _buildHeader('Nominal', center: true),
                _buildHeader('Status', center: true),
                _buildHeader('Bukti Pembayaran', alignRight: true),
              ],
            ),
          ),

          // DATA
          if (validData.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Tidak ada data',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: validData.length,
              itemBuilder: (context, index) {
                final tx = validData[index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          _buildCell(tx['tanggal']),
                          _buildCell(tx['nama'], center: true),
                          _buildCell(tx['jenis'], center: true),
                          _buildCell(tx['nominal'], center: true),
                          _buildCell(tx['status'], center: true),
                          _buildCell(tx['bukti pembayaran'], alignRight: true),
                        ],
                      ),
                    ),
                    // Divider untuk setiap baris
                    Container(
                      height: 1,
                      color: darkGreen.withOpacity(0.2),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(String text,
      {bool center = false, bool alignRight = false}) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: alignRight
            ? TextAlign.right
            : (center ? TextAlign.center : TextAlign.left),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCell(String? text,
      {bool center = false, bool alignRight = false}) {
    return Expanded(
      flex: 2,
      child: Text(
        text ?? '-',
        textAlign: alignRight
            ? TextAlign.right
            : (center ? TextAlign.center : TextAlign.left),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}