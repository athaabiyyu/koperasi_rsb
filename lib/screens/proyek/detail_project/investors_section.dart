import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';

class InvestorsTab extends StatelessWidget {
  final ProjectListItem project;

  const InvestorsTab({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
          const SizedBox(height: 20),
          Text(
            'Penanam Modal',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          const InvestorList(),
        ],
      ),
    );
  }
}

class InvestorList extends StatelessWidget {
  const InvestorList({super.key});

  // Dummy data - bisa diganti dengan data dari API
  static const List<Map<String, dynamic>> _investors = [
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
          InvestorTile(data: _investors[i]),
          if (i != _investors.length - 1)
            const Divider(height: 20, thickness: 0.7, color: Color(0xFFE5E7EB)),
        ],
      ],
    );
  }
}

class InvestorTile extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const InvestorTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final name = data['name'] as String? ?? '-';
    final avatar = data['avatar'] as String?;
    final tokens = data['tokens'] as int? ?? 0;
    final amount = data['amount'] as int? ?? 0;
    final date = data['date'] as String? ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: deviceWidth * 0.07,
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
                  SizedBox(width: deviceWidth * 0.02),
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
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}