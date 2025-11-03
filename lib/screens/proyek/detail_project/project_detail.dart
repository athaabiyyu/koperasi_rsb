import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/project_information_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/status_project_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/investors_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/funding_history_section.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectId;
  final String? imageUrl;
  final String? status;
  final String? title;
  final String? owner;
  final int? collectedToken;
  final int? remainingDays;
  final int? maxToken;
  final String? projectOwnerId;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.imageUrl,
    this.status,
    this.title,
    this.owner,
    this.collectedToken,
    this.remainingDays,
    this.maxToken,
    this.projectOwnerId,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  ProjectListItem? _projectDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProjectDetail();
  }

  Future<void> _loadProjectDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      final detail = await projectProvider.getProjectDetail(widget.projectId);

      if (mounted) {
        setState(() {
          _projectDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _handleBuyToken() {
    // TODO: Implement buy token logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur beli token akan segera hadir'),
        backgroundColor: Colors.green,
      ),
    );
    // Navigate to buy token page
    // Navigator.pushNamed(context, '/buy-token', arguments: widget.projectId);
  }

  void _handleDownloadProspectus() {
    // TODO: Implement download prospectus logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengunduh prospektus...'),
        backgroundColor: Colors.blue,
      ),
    );
    // Call API to download prospectus
    // final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    // await projectProvider.downloadProspectus(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_error != null || _projectDetail == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error ?? 'Gagal memuat detail proyek',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProjectDetail,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final project = _projectDetail!;

    // Get user info from AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.userId;
    final userRole = authProvider.userRole;

    // Check if current user is the project owner
    final isProjectOwner = project.user.id == currentUserId;

    // Check if user is PLATINUM
    final isPlatinum = userRole == 'PLATINUM';

    // Determine which tabs to show
    List<Tab> tabs = [];
    List<Widget> tabViews = [];

    // Tab 1: Informasi Proyek (Always visible)
    tabs.add(const Tab(text: 'Informasi Proyek'));
    tabViews.add(ProjectInformationTab(project: project));

    // Tab 2: Status Pengajuan
    // Show if: BASIC user OR (PLATINUM user AND is project owner)
    if (userRole == 'BASIC' || (userRole == 'PLATINUM' && isProjectOwner)) {
      tabs.add(const Tab(text: 'Status Pengajuan'));
      tabViews.add(SubmissionStatusTab(project: project));
    }

    // Tab 3: Penanam Modal (Always visible)
    tabs.add(const Tab(text: 'Penanam Modal'));
    tabViews.add(InvestorsTab(project: project));

    // Tab 4: Riwayat Pendanaan Dari Koperasi
    // Show if: BASIC user OR (PLATINUM user AND is project owner)
    if (userRole == 'BASIC' || (userRole == 'PLATINUM' && isProjectOwner)) {
      tabs.add(const Tab(text: 'Riwayat Pendanaan Dari Koperasi'));
      tabViews.add(FundingHistoryTab(project: project));
    }

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
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
        // Bottom action buttons - only show for PLATINUM users
        bottomNavigationBar: isPlatinum
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _handleBuyToken,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.shopping_cart, size: 20),
                          label: Text(
                            'Beli Token',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _handleDownloadProspectus,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkGreen,
                            side: BorderSide(color: darkGreen, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.download, size: 20),
                          label: Text(
                            'Prospektus',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}