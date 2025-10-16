import 'package:flutter/material.dart';
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
    _allItems = List.generate(
      20,
      (i) => {
        'title': 'Proyek #$i',
        'owner': 'Pemilik #$i',
        'status': i % 3 == 0 ? 'Proyek Selesai' : 'Proyek Berjalan',
        'modal': 20 + i,
        'hasil': 8 + (i % 20),
      },
    );
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
                final percent = modal == 0
                    ? 0.0
                    : (hasil / modal).clamp(0.0, 1.0);

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
                              child: Text(
                                it['title'] as String,
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

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah Modal (Lot)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$modal Lot',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  width: 16,
                                  thickness: 1,
                                  color: Colors.grey.shade200,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Perkiraan Hasil',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: LinearProgressIndicator(
                                                value: percent,
                                                minHeight: 8,
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(darkGreen),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${(percent * 100).toStringAsFixed(0)}%',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$hasil/$modal Lot',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
