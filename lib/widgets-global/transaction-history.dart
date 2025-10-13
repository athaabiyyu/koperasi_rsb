import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TransactionItem extends StatelessWidget {
  final String title; // Simpanan Wajib / Simpanan Pokok
  final String date; // 12 Agustus 2025
  final String amount; // Rp 120.000
  final bool isSuccess; // true = berhasil, false = gagal
  final String statusLabel; // "Berhasil" / "Belum Membayar"

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isSuccess,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ⬅️ sejajarkan tengah
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? darkGreen : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),

          // Detail transaksi (dibuat sejajar tengah dengan ikon)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // ⬅️ teks agak tengah
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Nominal + Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center, // ⬅️ sejajar tengah juga
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: _deviceHeight * 0.01),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * 0.03,
                  vertical: _deviceHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? darkGreen.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSuccess ? darkGreen : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
