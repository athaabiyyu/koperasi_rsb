import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/utils/currency_helper.dart';
import '../../providers/project_provider.dart';

class ProjectHeaderInfo extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String title;
  final String owner;
  final int maxToken;
  final int nominalDisetujui;
  final int hargaPerUnit;
  final int minimalPembelian;
  final int maksimalPembelian;
  final DateTime? selesaiPenggalanganDana;

  const ProjectHeaderInfo({
    super.key,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.owner,
    required this.maxToken,
    required this.nominalDisetujui,
    required this.hargaPerUnit,
    required this.minimalPembelian,
    required this.maksimalPembelian,
    this.selesaiPenggalanganDana,
  });

  int _calculateRemainingDays() {
    if (selesaiPenggalanganDana == null) return 0;
    final now = DateTime.now();
    final difference = selesaiPenggalanganDana!.difference(now);
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        // ✅ Get real-time data from provider
        final collectedToken = provider.collectedToken;
        final remainingToken = provider.remainingToken;
        final isLoadingInvestors = provider.isLoadingInvestors;
        
        // Calculate progress
        final progress = maxToken > 0 
            ? (collectedToken / maxToken).clamp(0.0, 1.0) 
            : 0.0;
        
        final progressPercentage = (progress * 100).toStringAsFixed(1);
        final remainingDays = _calculateRemainingDays();
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
                  radius: deviceWidth * 0.08,
                  backgroundImage: NetworkImage(imageUrl),
                  onBackgroundImageError: (_, __) {},
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.business, size: 32)
                      : null,
                ),
                SizedBox(width: deviceWidth * 0.04),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.03,
                        vertical: deviceHeight * 0.008,
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
            SizedBox(height: deviceHeight * 0.02),

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
            SizedBox(height: deviceHeight * 0.015),

            // ✅ Loading indicator for token data
            if (isLoadingInvestors)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else ...[
              // Progress bar with percentage label
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.orange,
                      minHeight: 16,
                    ),
                  ),
                  // Percentage text overlay (if progress > 5%)
                  if (progress > 0.05)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '$progressPercentage%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.01),

              // ✅ Real-time token statistics
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
                      Row(
                        children: [
                          Text(
                            "$collectedToken Token",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "($progressPercentage%)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: remainingDays < 7 
                              ? Colors.red 
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.01),

              // Token remaining info
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Tersisa $remainingToken token dari $maxToken",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
            
            SizedBox(height: deviceHeight * 0.015),
            const Divider(),
            SizedBox(height: deviceHeight * 0.01),

            // Info detail target/token/dll
            _buildInfoRow("Target Dana", CurrencyUtils.formatRupiah(nominalDisetujui), deviceHeight),
            _buildInfoRow(
              "Token Tersisa",
              "$remainingToken token",
              deviceHeight,
              valueColor: remainingToken > 0 ? Colors.green : Colors.red,
            ),
            _buildInfoRow("Jumlah Token", "$maxToken token", deviceHeight),
            _buildInfoRow("Harga per Token", CurrencyUtils.formatRupiah(hargaPerUnit), deviceHeight),
            _buildInfoRow(
              "Min Pembelian",
              "$minimalPembelian token (${CurrencyUtils.formatRupiah(minBeliRupiah)})",
              deviceHeight,
            ),
            _buildInfoRow(
              "Maks Pembelian",
              "$maksimalPembelian token (${CurrencyUtils.formatRupiah(maxBeliRupiah)})",
              deviceHeight,
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(
    String label, 
    String value, 
    double deviceHeight, 
    {Color? valueColor}
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.004),
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
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
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