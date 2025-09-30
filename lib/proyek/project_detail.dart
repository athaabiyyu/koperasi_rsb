import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import '../widgets-global/reusable-page/timeline_widgets.dart';
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

    final bool isRunning = status == 'Proyek Berjalan';
    final tabs = <Tab>[
      const Tab(text: 'Informasi Proyek'),
      const Tab(text: 'Status Pengajuan'),
      if (isRunning) const Tab(text: 'Penanam Modal'),
      if (isRunning) const Tab(text: 'Riwayat Pendanaan Dari Koperasi'),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
            indicatorColor: darkGreen,
            labelColor: darkGreen,
            unselectedLabelColor: Colors.grey,
            isScrollable: isRunning, // allow scroll when many tabs
            tabs: tabs,
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
                    "Saya yakin produk ini memiliki permintaan tinggi dan akan menguntungkan.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
                    "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
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
                      SizedBox(width: 4),
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
                              child: DashedLineVertical(
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
                          (index) => TimelineStepItem(
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
            if (isRunning)
              // ================= PENANAM MODAL =================
              SingleChildScrollView(
                padding: EdgeInsets.all(_deviceWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Project Info (requested to show also here)
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
                    Text(
                      'Penanam Modal',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InvestorList(),
                  ],
                ),
              ),
            if (isRunning)
              // ================= RIWAYAT PENDANAAN DARI KOPERASI =================
              SingleChildScrollView(
                padding: EdgeInsets.all(_deviceWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Pendanaan Dari Koperasi',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada riwayat pendanaan koperasi (dummy placeholder).',
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
// ================= PENANAM MODAL LIST WIDGET =================
class _InvestorList extends StatelessWidget {
  _InvestorList();

  final List<Map<String, dynamic>> _investors = const [
    {
      'name': 'Albertina Caseus',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'tokens': 100,
      'amount': 2000000,
      'date': '29 Mar 2025 10:00 WIB',
    },
    {
      'name': 'Albertina Caseus',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'tokens': 100,
      'amount': 2000000,
      'date': '29 Mar 2025 10:00 WIB',
    },
    {
      'name': 'Albertina Caseus',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'tokens': 100,
      'amount': 2000000,
      'date': '29 Mar 2025 10:00 WIB',
    },
    {
      'name': 'Albertina Caseus',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'tokens': 100,
      'amount': 2000000,
      'date': '29 Mar 2025 10:00 WIB',
    },
    {
      'name': 'Albertina Caseus',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'tokens': 100,
      'amount': 2000000,
      'date': '29 Mar 2025 10:00 WIB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _investors.length; i++) ...[
          _InvestorTile(data: _investors[i]),
          if (i != _investors.length - 1)
            const Divider(height: 20, thickness: 0.7, color: Color(0xFFE5E7EB)),
        ],
      ],
    );
  }
}

class _InvestorTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _InvestorTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final name = data['name'] as String? ?? '-';
    final avatar = data['avatar'] as String?;
    final tokens = data['tokens'] as int? ?? 0;
    final amount = data['amount'] as int? ?? 0;
    final date = data['date'] as String? ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: _deviceWidth * 0.07,
          backgroundColor: const Color(0xFFE5E7EB),
          backgroundImage: avatar != null ? NetworkImage(avatar) : null,
          child: avatar == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101828),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: const Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: _deviceWidth * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$tokens Koin',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRupiah(amount),
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF027A48),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRupiah(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ' + buffer.toString().split('').reversed.join();
  }
}

// Garis Vertikal Putus-putus
// (timeline widgets & dashed utilities moved to widgets/timeline_widgets.dart)
