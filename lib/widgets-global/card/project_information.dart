import 'package:flutter/material.dart';
// Removed unused colors import; status colors are defined inline here to match MyProjectCard

class ProjectHeaderInfo extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String title;
  final String owner;
  final int collectedToken;
  final int remainingDays;
  final int maxToken;

  const ProjectHeaderInfo({
    super.key,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.owner,
    required this.collectedToken,
    required this.remainingDays,
    required this.maxToken,
  });

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    final progress = (collectedToken / maxToken).clamp(0.0, 1.0);
    final style = _getStatusStyle(status);

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
        _buildInfoRow("Target Dana", "Rp 250.000.000", _deviceHeight),
        _buildInfoRow(
          "Token Rilis",
          "${maxToken - collectedToken}",
          _deviceHeight,
        ),
        _buildInfoRow("Jumlah Token", "$maxToken", _deviceHeight),
        _buildInfoRow("Harga per Token", "Rp 250.000", _deviceHeight),
        _buildInfoRow("Min Pembelian", "2 atau Rp 500.000", _deviceHeight),
        _buildInfoRow("Maks Pembelian", "10 atau Rp 2.500.000", _deviceHeight),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.001),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
      default:
        return {"bg": Colors.grey.shade200, "fg": Colors.grey.shade700};
    }
  }
}
