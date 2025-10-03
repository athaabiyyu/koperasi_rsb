import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
        appBar: AppBar(
          title: const Text("Detail Proyek"),
          bottom: const TabBar(
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
                          color: Colors.green,
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
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text("2.3 MB"),
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12),
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
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text("2.3 MB"),
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12),
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
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
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
                  const Text(
                    "Progres Status Pengajuan Project",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: _deviceHeight * 0.02),

                  // Render timeline
                  ...List.generate(timeline.length, (index) {
                    final step = timeline[index];
                    final isFirst = index == 0;
                    final isLast = index == timeline.length - 1;

                    return TimelineTile(
                      alignment: TimelineAlign.start,
                      isFirst: isFirst,
                      isLast: isLast,
                      indicatorStyle: IndicatorStyle(
                        width: 30,
                        color: step["events"].isEmpty
                            ? Colors.grey
                            : step["events"].any((e) => e["type"] == "error")
                            ? Colors.red
                            : Colors.green,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: step["events"].isEmpty
                              ? Icons.lock
                              : Icons.check,
                        ),
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step["step"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...step["events"].map<Widget>((event) {
                              Color borderColor;
                              switch (event["type"]) {
                                case "success":
                                  borderColor = Colors.green;
                                  break;
                                case "error":
                                  borderColor = Colors.red;
                                  break;
                                default:
                                  borderColor = Colors.grey;
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event["message"],
                                      style: TextStyle(color: borderColor),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      event["date"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
