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
                _buildHeader('Tanggal', flex: 2),
                _buildHeader('Status', flex: 2, center: true),
                _buildHeader('Aksi', flex: 1, center: true),
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
                          _buildCell(tx['tanggal'], flex: 2),
                          _buildCell(tx['status'], flex: 2, center: true),
                          _buildActionButton(context, tx),
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
      {int flex = 1, bool center = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCell(String? text,
      {int flex = 1, bool center = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text ?? '-',
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Map<String, String> data) {
    return Expanded(
      flex: 1,
      child: Center(
        child: InkWell(
          onTap: () => _showDetailDialog(context, data),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Detail',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Transaksi',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Tanggal', data['tanggal'] ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Nama', data['nama'] ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Jenis Transaksi', data['jenis'] ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Nominal', data['nominal'] ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Status', data['status'] ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Bukti Pembayaran', data['bukti pembayaran'] ?? '-'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}