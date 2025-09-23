import 'package:flutter/material.dart';

class MyProjectCard extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String title;
  final int tokenDitawarkan;
  final int minBeli;
  final int terkumpul;
  final int sisaHari;
  final bool isDraft;

  const MyProjectCard({
    super.key,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.tokenDitawarkan,
    required this.minBeli,
    required this.terkumpul,
    required this.sisaHari,
    this.isDraft = false,
  });

  // Fungsi untuk ambil warna sesuai status
  Map<String, dynamic> _getStatusStyle() {
    switch (status) {
      case "Pendanaan Dibuka":
        return {
          "bg": const Color(0xFFE7FFF4),
          "fg": const Color(0xFF0D804A),
        };
      case "Proyek Berjalan":
        return {
          "bg": const Color(0xFFEDF8FF),
          "fg": const Color(0xFF1D8AD9),
        };
      case "Proyek Selesai":
        return {
          "bg": const Color(0xFFE7FFF4),
          "fg": const Color(0xFF0D804A),
        };
      case "Proyek Dibatalkan":
        return {
          "bg": const Color(0xFFFFDDD6),
          "fg": const Color(0xFF922922),
        };
      case "Draft Proyek":
        return {
          "bg": const Color(0xFFF8F8F8),
          "fg": const Color(0xFF000000),
        };
      default:
        return {
          "bg": Colors.grey.shade200,
          "fg": Colors.grey.shade700,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;

    final progress = (isDraft || tokenDitawarkan == 0)
        ? 0.0
        : (terkumpul / tokenDitawarkan).clamp(0.0, 1.0);

    // Ambil style status
    final style = _getStatusStyle();

    // Fungsi untuk tampilkan angka atau "-"
    String displayValue(dynamic value) {
      return isDraft ? "-" : "$value";
    }

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_deviceWidth * 0.03),
      ),
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.01,
        horizontal: _deviceWidth * 0.02,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.06,
          vertical: _deviceHeight * 0.025,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris pertama: Gambar + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: _deviceWidth * 0.07,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth * 0.025,
                    vertical: _deviceHeight * 0.004,
                  ),
                  decoration: BoxDecoration(
                    color: style["bg"],
                    borderRadius: BorderRadius.circular(_deviceWidth * 0.05),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: _deviceWidth * 0.03,
                      color: style["fg"],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: _deviceHeight * 0.02),

            // Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            SizedBox(height: _deviceHeight * 0.018),

            // Token Ditawarkan & Min Beli
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayValue(tokenDitawarkan),
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Token Ditawarkan",
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      displayValue(minBeli),
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: _deviceHeight * 0.002),
                    Text(
                      "Min. Beli",
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: _deviceHeight * 0.015),

            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.orange,
              minHeight: 10,
              borderRadius: BorderRadius.circular(4),
            ),

            SizedBox(height: _deviceHeight * 0.01),

            // Terkumpul & Sisa Hari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terkumpul",
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: _deviceHeight * 0.002),
                    Text(
                      displayValue(terkumpul),
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Sisa Hari",
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      displayValue(sisaHari),
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
