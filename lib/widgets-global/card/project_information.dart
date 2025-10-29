import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectHeaderInfo extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String title;
  final String owner;
  final int collectedToken;
  final int remainingDays;
  final int maxToken;
  final int nominalDisetujui;
  final int hargaPerUnit;
  final int minimalPembelian;
  final int maksimalPembelian;

  const ProjectHeaderInfo({
    super.key,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.owner,
    required this.collectedToken,
    required this.remainingDays,
    required this.maxToken,
    required this.nominalDisetujui,
    required this.hargaPerUnit,
    required this.minimalPembelian,
    required this.maksimalPembelian,
  });

  String _formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    final progress = maxToken > 0 ? (collectedToken / maxToken).clamp(0.0, 1.0) : 0.0;
    final style = _getStatusStyle(status);

    // Calculate min and max in rupiah
    final minBeliRupiah = minimalPembelian * hargaPerUnit;
    final maxBeliRupiah = maksimalPembelian * hargaPerUnit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Foto + Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: _deviceWidth * 0.08,
              backgroundImage: NetworkImage(imageUrl),
              onBackgroundImageError: (_, __) {},
              child: imageUrl.isEmpty
                  ? const Icon(Icons.business, size: 32)
                  : null,
            ),
            SizedBox(width: _deviceWidth * 0.04),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth * 0.03,
                    vertical: _deviceHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: style["bg"],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: style["fg"],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: _deviceHeight * 0.02),

        // Judul + Owner
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          owner,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _deviceHeight * 0.015),

        // Progress bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          color: Colors.orange,
          minHeight: 10,
          borderRadius: BorderRadius.circular(6),
        ),
        SizedBox(height: _deviceHeight * 0.01),

        // Terkumpul + Sisa Hari
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Terkumpul",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "$collectedToken Token",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Sisa Hari",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "$remainingDays",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: _deviceHeight * 0.015),

        // Info detail target/token/dll
        _buildInfoRow("Target Dana", _formatRupiah(nominalDisetujui), _deviceHeight),
        _buildInfoRow(
          "Token Rilis",
          "${maxToken - collectedToken}",
          _deviceHeight,
        ),
        _buildInfoRow("Jumlah Token", "$maxToken", _deviceHeight),
        _buildInfoRow("Harga per Token", _formatRupiah(hargaPerUnit), _deviceHeight),
        _buildInfoRow(
          "Min Pembelian",
          "$minimalPembelian atau ${_formatRupiah(minBeliRupiah)}",
          _deviceHeight,
        ),
        _buildInfoRow(
          "Maks Pembelian",
          "$maksimalPembelian atau ${_formatRupiah(maxBeliRupiah)}",
          _deviceHeight,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.001),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStatusStyle(String status) {
    switch (status) {
      case "Pendanaan Dibuka":
        return {"bg": const Color(0xFFE7FFF4), "fg": const Color(0xFF0D804A)};
      case "Proyek Berjalan":
        return {"bg": const Color(0xFFEDF8FF), "fg": const Color(0xFF1D8AD9)};
      case "Proyek Selesai":
        return {"bg": const Color(0xFFE7FFF4), "fg": const Color(0xFF0D804A)};
      case "Proyek Dibatalkan":
        return {"bg": const Color(0xFFFFDDD6), "fg": const Color(0xFF922922)};
      case "Draft Proyek":
        return {"bg": const Color(0xFFF8F8F8), "fg": const Color(0xFF000000)};
      case "Proses Verifikasi":
        return {"bg": const Color(0xFFFFF4E6), "fg": const Color(0xFFD97706)};
      case "Revisi":
        return {"bg": const Color(0xFFFEF3C7), "fg": const Color(0xFFB45309)};
      case "Approval":
        return {"bg": const Color(0xFFDDEAFF), "fg": const Color(0xFF1E40AF)};
      case "TTD Kontrak":
        return {"bg": const Color(0xFFE0E7FF), "fg": const Color(0xFF4338CA)};
      case "Ditolak":
        return {"bg": const Color(0xFFFFE4E6), "fg": const Color(0xFFDC2626)};
      default:
        return {"bg": Colors.grey.shade200, "fg": Colors.grey.shade700};
    }
  }
}