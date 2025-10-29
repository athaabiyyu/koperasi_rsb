import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/widgets-global/tabel/tabel-transaksi.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';

class FundingHistoryTab extends StatelessWidget {
  final ProjectListItem project;

  const FundingHistoryTab({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // Dummy data - bisa diganti dengan data dari API
    final List<Map<String, String>> fundingHistory = [
      {
        'tanggal': '15-04-2024\n13:28:08',
        'metode': 'Transfer Bank',
        'nominal': 'Rp. 1.000.000',
      },
      {
        'tanggal': '15-04-2024\n10:05:22',
        'metode': 'Transfer Bank',
        'nominal': 'Rp. 2.500.000',
      },
      {
        'tanggal': '14-04-2024\n18:40:11',
        'metode': 'VA BSI',
        'nominal': 'Rp. 750.000',
      },
      {
        'tanggal': '14-04-2024\n09:12:47',
        'metode': 'VA BSI',
        'nominal': 'Rp. 1.250.000',
      },
      {
        'tanggal': '13-04-2024\n16:30:05',
        'metode': 'Transfer Bank',
        'nominal': 'Rp. 5.000.000',
      },
      {
        'tanggal': '13-04-2024\n08:22:33',
        'metode': 'Transfer Bank',
        'nominal': 'Rp. 3.000.000',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(deviceWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectHeaderInfo(
            imageUrl: project.mainImageUrl,
            status: project.statusDisplay,
            title: project.judul,
            owner: project.user.name,
            collectedToken: 0,
            remainingDays: project.sisaHari,
            maxToken: project.tokenDitawarkan,
            nominalDisetujui: project.nominalDisetujui ?? project.nominal,
            hargaPerUnit: project.hargaPerUnit ?? 0,
            minimalPembelian: project.minBeli,
            maksimalPembelian: project.maxBeli,
          ),
          const SizedBox(height: 24),

          Text(
            'Riwayat Pendanaan',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: deviceHeight * 0.50,
            child: TransactionTable(
              status: project.statusDisplay,
              data: fundingHistory,
            ),
          ),
        ],
      ),
    );
  }
}