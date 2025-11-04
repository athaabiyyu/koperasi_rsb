import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/models/project_investor_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class InvestorsTab extends StatefulWidget {
  final ProjectListItem project;

  const InvestorsTab({
    super.key,
    required this.project,
  });

  @override
  State<InvestorsTab> createState() => _InvestorsTabState();
}

class _InvestorsTabState extends State<InvestorsTab> {
  @override
  void initState() {
    super.initState();
    // ✅ Load investors using Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadProjectInvestors(widget.project.id);
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<ProjectProvider>().loadProjectInvestors(widget.project.id);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        final investors = provider.projectInvestors;
        final isLoading = provider.isLoadingInvestors;
        final errorMessage = provider.investorsError;

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(deviceWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Removed collectedToken parameter - now handled by Provider
                ProjectHeaderInfo(
                  imageUrl: widget.project.mainImageUrl,
                  status: widget.project.statusDisplay,
                  title: widget.project.judul,
                  owner: widget.project.user.name,
                  maxToken: widget.project.tokenDitawarkan,
                  nominalDisetujui: widget.project.nominalDisetujui ?? widget.project.nominal,
                  hargaPerUnit: widget.project.hargaPerUnit ?? 0,
                  minimalPembelian: widget.project.minBeli,
                  maksimalPembelian: widget.project.maxBeli,
                  selesaiPenggalanganDana: widget.project.selesaiPenggalanganDana,
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Penanam Modal',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (investors.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          '${investors.length} Investor',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Loading state
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                // Error state
                else if (errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal memuat data',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _handleRefresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Empty state
                else if (investors.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum Ada Investor',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Proyek ini belum memiliki investor.',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                // Data loaded
                else
                  InvestorList(investors: investors),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InvestorList extends StatelessWidget {
  final List<InvestorSummary> investors;

  const InvestorList({
    super.key,
    required this.investors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < investors.length; i++) ...[
          InvestorTile(investor: investors[i]),
          if (i != investors.length - 1)
            const Divider(height: 20, thickness: 0.7, color: Color(0xFFE5E7EB)),
        ],
      ],
    );
  }
}

class InvestorTile extends StatelessWidget {
  final InvestorSummary investor;
  
  const InvestorTile({
    super.key,
    required this.investor,
  });

  // Avatar colors palette
  static const List<Color> avatarColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF97316), // Orange
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFF6366F1), // Indigo
  ];

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final avatarColor = avatarColors[investor.avatarColorIndex];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: deviceWidth * 0.07,
          backgroundColor: avatarColor.withOpacity(0.2),
          child: Text(
            investor.initials,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: avatarColor,
            ),
          ),
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
                          investor.nama,
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
                          investor.formattedDate,
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
                        '${investor.jumlahToken} Koin',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        investor.formattedAmount,
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
}