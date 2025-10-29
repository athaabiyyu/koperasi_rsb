import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:provider/provider.dart';
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
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
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
    final bool isRunning = project.status == 'PENDANAAN DIBUKA';
    
    // Build tabs based on project status
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
            isScrollable: isRunning,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Informasi Proyek
            ProjectInformationTab(project: project),
            
            // Tab 2: Status Pengajuan
            SubmissionStatusTab(project: project),
            
            // Tab 3: Penanam Modal (only if running)
            if (isRunning) InvestorsTab(project: project),
            
            // Tab 4: Riwayat Pendanaan (only if running)
            if (isRunning) FundingHistoryTab(project: project),
          ],
        ),
      ),
    );
  }
}