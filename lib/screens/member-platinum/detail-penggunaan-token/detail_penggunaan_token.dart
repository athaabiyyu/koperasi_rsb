import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TokenUsageListPage extends StatefulWidget {
  const TokenUsageListPage({super.key});

  @override
  State<TokenUsageListPage> createState() => _TokenUsageListPageState();
}

class _TokenUsageListPageState extends State<TokenUsageListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<Map<String, dynamic>> _allItems;
  late List<Map<String, dynamic>> _visibleItems;

  @override
  void initState() {
    super.initState();
    // Dummy data yang lebih realistis (bukan "Proyek #1" dst)
    _allItems = [
      {
        'title': 'Stand Pisang Nugget',
        'owner': 'Budi Santoso',
        'status': 'Proyek Berjalan',
        'modal': 40,
        'hasil': 12,
      },
      {
        'title': 'Kopi Senja Nusantara',
        'owner': 'Sinta Dewi',
        'status': 'Proyek Berjalan',
        'modal': 55,
        'hasil': 9,
      },
      {
        'title': 'Laundry Kiloan Bersih',
        'owner': 'Rama Genta',
        'status': 'Proyek Selesai',
        'modal': 30,
        'hasil': 15,
      },
      {
        'title': 'Warung Sehat Harian',
        'owner': 'Wulan Pertiwi',
        'status': 'Proyek Berjalan',
        'modal': 25,
        'hasil': 7,
      },
      {
        'title': 'Ayam Bakar Madu',
        'owner': 'Rizal Akbar',
        'status': 'Proyek Berjalan',
        'modal': 60,
        'hasil': 10,
      },
      {
        'title': 'Martabak Mantul',
        'owner': 'Nadia Putri',
        'status': 'Proyek Selesai',
        'modal': 35,
        'hasil': 18,
      },
      {
        'title': 'Toko Sembako Harapan',
        'owner': 'Hendri Wijaya',
        'status': 'Proyek Berjalan',
        'modal': 48,
        'hasil': 11,
      },
      {
        'title': 'Percetakan Cepat Jadi',
        'owner': 'Sari Melati',
        'status': 'Proyek Berjalan',
        'modal': 28,
        'hasil': 6,
      },
      {
        'title': 'Frozen Food UMKM',
        'owner': 'Yoga Prasetyo',
        'status': 'Proyek Selesai',
        'modal': 52,
        'hasil': 20,
      },
      {
        'title': 'Bengkel Motor Jaya',
        'owner': 'Dedi Firmansyah',
        'status': 'Proyek Berjalan',
        'modal': 45,
        'hasil': 8,
      },
      {
        'title': 'Katering Rumahan Lestari',
        'owner': 'Desi Anggraini',
        'status': 'Proyek Berjalan',
        'modal': 33,
        'hasil': 9,
      },
      {
        'title': 'Usaha Jahit Keluarga',
        'owner': 'Teguh Wibowo',
        'status': 'Proyek Selesai',
        'modal': 22,
        'hasil': 13,
      },
    ];
    _visibleItems = List.from(_allItems);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _visibleItems = List.from(_allItems);
      } else {
        _visibleItems = _allItems.where((e) {
          final title = (e['title'] as String).toLowerCase();
          final owner = (e['owner'] as String).toLowerCase();
          return title.contains(query) || owner.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        title: Text(
          'Detail Penggunaan Token',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.05,
              height * 0.02,
              width * 0.05,
              0,
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari proyek atau pemilik',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: darkGreen, width: 1.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                width * 0.05,
                0,
                width * 0.05,
                height * 0.02,
              ),
              itemCount: _visibleItems.length,
              itemBuilder: (context, index) {
                final it = _visibleItems[index];
                final isSelesai = (it['status'] as String).contains('Selesai');
                final modal = it['modal'] as int;
                final hasil = it['hasil'] as int;
                // Progress percentage no longer used in the new two-box layout.

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                it['title'] as String,
                                maxLines: 2,
                                minFontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelesai
                                    ? Colors.green.withOpacity(0.12)
                                    : Colors.blue.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                it['status'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: isSelesai ? darkGreen : Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          it['owner'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '$modal',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Jumlah Token',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Rp 0',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Return: ($hasil)',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
        ],
      ),
    );
  }
}
