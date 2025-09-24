import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
// TODO: Memecah Timeline menjadi File Baru, Membuat file yang di upload menjadi clickable dan bisa di preview

class ProjectDetailPage extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String title;
  final String owner;
  final int collectedToken;
  final int remainingDays;
  final int maxToken;

  const ProjectDetailPage({
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

    // ===== Dummy data timeline =====
    final List<Map<String, dynamic>> timeline = [
      {
        "step": "Proposal Project Terkirim",
        "events": [
          {
            "type": "success",
            "message":
                "Proposal project Anda berhasil terkirim dan akan diperiksa oleh Tim Kami",
            "date": "22 Jan 2025, 4:23 PM",
          },
        ],
      },
      {
        "step": "Peninjauan Proposal",
        "events": [
          {
            "type": "error",
            "message":
                "Mohon upload dokumen laporan keuangan melengkapi syarat pengajuan modal usaha Anda.",
            "date": "22 Jan 2025, 4:50 PM",
          },
          {
            "type": "success",
            "message":
                "Proposal project Anda telah memenuhi syarat, selanjutnya akan dilakukan proses approval dari komite koperasi",
            "date": "22 Jan 2025, 6:00 PM",
          },
        ],
      },
      {
        "step": "Proses Approval dari Komite Koperasi",
        "events": [
          {
            "type": "info",
            "message": "Project sedang dalam proses approval komite koperasi",
            "date": "23 Jan 2025, 10:00 AM",
          },
        ],
      },
      {"step": "Kontrak Perjanjian", "events": []},
      {"step": "Proses Penggalangan Penyertaan Modal", "events": []},
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
          bottom: const TabBar(
            indicatorColor: darkGreen,
            labelColor: darkGreen,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Informasi Proyek"),
              Tab(text: "Status Pengajuan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ================= INFORMASI PROYEK =================
            SingleChildScrollView(
              padding: EdgeInsets.all(_deviceWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Project Info
                  ProjectHeaderInfo(
                    imageUrl: imageUrl,
                    status: status,
                    title: title,
                    owner: owner,
                    collectedToken: collectedToken,
                    remainingDays: remainingDays,
                    maxToken: maxToken,
                  ),
                  const SizedBox(height: 20),

                  // ===== Deskripsi Proyek =====
                  const Text(
                    "Deskripsi Proyek",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(height: _deviceHeight * 0.012),

                  const Text(
                    "Saya membutuhkan modal untuk mendirikan sebuah stand pisang nugget di Green Terrace. "
                    "Dana akan digunakan untuk bahan baku, alat, dan perlengkapan. "
                    "Saya yakin produk ini memiliki permintaan tinggi dan akan menguntungkan.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: _deviceHeight * 0.025),

                  // ===== Pembagian Keuntungan =====
                  const Text(
                    "Pembagian Keuntungan",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(height: _deviceHeight * 0.012),
                  const Text(
                    "Pada tahun pertama dan kedua, penyerta modal mendapatkan 50% keuntungan "
                    "dan pengelola 50%. Tahun ketiga dan seterusnya, pembagian menjadi 50:50 "
                    "hingga modal kembali.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: _deviceHeight * 0.012),

                  Row(
                    children: const [
                      Text(
                        "Laporan Laba Rugi Diupdate Setiap: ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "6 Bulan",
                        style: TextStyle(
                          color: darkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _deviceHeight * 0.025),

                  // ===== Lampiran Proyek =====
                  const Text(
                    "Lampiran Proyek",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(height: _deviceHeight * 0.012),

                  Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(_deviceWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey,
                          ),
                        ),
                        title: const Text(
                          "Foto Produk Pisang Nugget.jpg",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text("2.3 MB"),
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(_deviceWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey,
                          ),
                        ),
                        title: const Text(
                          "Konsep Stand.jpg",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text("2.3 MB"),
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(_deviceWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey,
                          ),
                        ),
                        title: const Text(
                          "Dokumen Proyeksi Proyek.xls",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text("2.3 MB"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= STATUS PENGAJUAN =================
            SingleChildScrollView(
              padding: EdgeInsets.all(_deviceWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Project Info
                  ProjectHeaderInfo(
                    imageUrl: imageUrl,
                    status: status,
                    title: title,
                    owner: owner,
                    collectedToken: collectedToken,
                    remainingDays: remainingDays,
                    maxToken: maxToken,
                  ),
                  const SizedBox(height: 20),

                  // Judul Timeline
                  Text(
                    "Progres Status Pengajuan Project",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: _deviceHeight * 0.02),

                  // Render custom dashed timeline with a full-height dashed line behind steps
                  Stack(
                    children: [
                      // Background dashed vertical line aligned to dot center
                      Positioned.fill(
                        child: Padding(
                          // Center of the 32px indicator column
                          padding: const EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: 1,
                              child: _DashedLineVertical(
                                color: const Color(0xFFBBBBBB),
                                thickness: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          timeline.length,
                          (index) => _TimelineStepItem(
                            index: index,
                            isLast: index == timeline.length - 1,
                            title: timeline[index]["step"],
                            events: List<Map<String, dynamic>>.from(
                              timeline[index]["events"],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Box Timeline
class _TimelineStepItem extends StatelessWidget {
  final int index;
  final bool isLast;
  final String title;
  final List<Map<String, dynamic>> events;

  const _TimelineStepItem({
    required this.index,
    required this.isLast,
    required this.title,
    required this.events,
  });

  bool get isDone => events.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    const lineColor = lightGreen;
    const successColor = Color(0xFF12B76A);
    const neutralColor = Color(0xFF98A2B3);
    const dangerColor = Colors.red;

    return Padding(
      padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: indicator only; connecting dashed line is drawn behind via Stack
          SizedBox(
            width: 32,
            child: Center(
              child: isDone
                  ? Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        border: Border.all(color: lineColor),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(  
                        "${index + 1}",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: neutralColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),

          SizedBox(width: deviceWidth * 0.02),

          // Right: content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: successColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "22 Januari, 2022 4:23 PM by",
                  style: GoogleFonts.roboto(fontSize: 12, color: neutralColor),
                ),
                const SizedBox(height: 10),

                ...events.map((event) {
                  final type = event['type'] as String? ?? 'info';
                  Color borderColor;
                  switch (type) {
                    case 'success':
                      borderColor = successColor;
                      break;
                    case 'error':
                      borderColor = dangerColor;
                      break;
                    default:
                      borderColor = const Color(0xFFD0D5DD); // abu muda
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: _DashedBorderShape(
                        color: borderColor,
                        strokeWidth: 1.2,
                        dashLength: 6,
                        gapLength: 4,
                        borderRadius: 8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['message'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: borderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (event['date'] != null)
                          Text(
                            event['date'],
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: neutralColor,
                            ),
                          ),
                        if (event['actionLabel'] != null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: successColor),
                                foregroundColor: successColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(event['actionLabel']),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Garis Vertikal Putus-putus
class _DashedLineVertical extends StatelessWidget {
  final double thickness;
  final Color color;

  const _DashedLineVertical({this.thickness = 1, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dashLength = 4;
        const double gapLength = 4;
        final height = constraints.maxHeight;
        final dashCount = (height / (dashLength + gapLength)).floor();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (index) {
            return SizedBox(
              height: dashLength,
              child: Center(
                child: Container(width: thickness, color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

// Garis Putus-putus Border
class _DashedBorderShape extends OutlinedBorder {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  const _DashedBorderShape({
    required this.color,
    this.strokeWidth = 1,
    this.dashLength = 6,
    this.gapLength = 4,
    this.borderRadius = 8,
  });

  @override
  OutlinedBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
  }) {
    return _DashedBorderShape(
      color: color,
      strokeWidth: strokeWidth,
      dashLength: dashLength,
      gapLength: gapLength,
      borderRadius: this.borderRadius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    // create dashed path
    final dashedPath = _createDashedPath(path, dashLength, gapLength);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double gapLength) {
    final Path dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0.0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    return dashedPath;
  }

  @override
  ShapeBorder scale(double t) => this;
}
