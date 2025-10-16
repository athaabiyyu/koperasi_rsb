import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isSuccess;
  final String statusLabel;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isSuccess,
    required this.statusLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon seperti kode 1
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? darkGreen : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),

          // Detail transaksi - seperti kode 1
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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

          // Nominal + Status - seperti kode 1
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
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

// Versi enhanced dengan 3 status (success, pending, failed) seperti kode 2
class TransactionItemEnhanced extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String status; // 'success', 'pending', 'failed'
  final String statusLabel;

  const TransactionItemEnhanced({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusLabel,
  }) : super(key: key);

  // Get icon based on status - menggunakan icon seperti kode 1
  IconData get _statusIcon {
    switch (status.toLowerCase()) {
      case 'success':
      case 'berhasil':
      case 'sukses':
        return Icons.check_circle;           // ✅ Centang
      case 'failed':
      case 'gagal':
        return Icons.cancel;                 // ❌ Silang
      case 'pending':
      case 'menunggu':
      default:
        return Icons.access_time_rounded;    // ⏱️ Jam
    }
  }

  // Get color based on status - menggunakan warna seperti kode 1
  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'success':
      case 'berhasil':
      case 'sukses':
        return darkGreen; // Menggunakan darkGreen dari kode 1
      case 'failed':
      case 'gagal':
        return Colors.red; // Menggunakan Colors.red seperti kode 1
      case 'pending':
      case 'menunggu':
      default:
        return Colors.orange; // Warna untuk pending
    }
  }

  // Get background color based on status - menggunakan opacity seperti kode 1
  Color get _statusBgColor {
    switch (status.toLowerCase()) {
      case 'success':
      case 'berhasil':
      case 'sukses':
        return darkGreen.withOpacity(0.1); // Seperti kode 1
      case 'failed':
      case 'gagal':
        return Colors.red.withOpacity(0.1); // Seperti kode 1
      case 'pending':
      case 'menunggu':
      default:
        return Colors.orange.withOpacity(0.1); // Untuk pending
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon seperti kode 1
          Icon(
            _statusIcon,
            color: _statusColor,
            size: 28,
          ),
          const SizedBox(width: 12),

          // Detail transaksi - seperti kode 1
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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

          // Nominal + Status - seperti kode 1
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  color: _statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _statusColor,
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