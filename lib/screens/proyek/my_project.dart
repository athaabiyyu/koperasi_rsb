import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/my_project_card.dart';
import 'package:koperasi_rsb/screens/proyek/add_project.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/project_detail.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/navigation/pagination_table.dart';

class MyProjectPage extends StatefulWidget {
  final bool fromProjectList;

  const MyProjectPage({super.key, this.fromProjectList = false});

  @override
  State<MyProjectPage> createState() => _MyProjectPageState();
}

class _MyProjectPageState extends State<MyProjectPage>
    with SingleTickerProviderStateMixin {
  int _sortIndex = 0; // 0 = Terbaru, 1 = Terlama
  bool _isInitialized = false;
  
  // Pagination state untuk setiap tab
  final Map<String, int> _currentPages = {
    'PROSES_VERIFIKASI': 1,
    'PENDANAAN DIBUKA': 1,
    'BERJALAN': 1,
    'SELESAI': 1,
    'DIBATALKAN': 1,
    'DRAFT': 1,
  };
  final int _itemsPerPage = 5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadProjects();
      _isInitialized = true;
    }
  }

  Future<void> _loadProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    await projectProvider.loadUserProjects();
  }

  Future<void> _refreshProjects() async {
    await _loadProjects();
    // Reset semua halaman ke 1 setelah refresh
    setState(() {
      _currentPages.updateAll((key, value) => 1);
    });
  }

  void _goToNextPage(String statusFilter) {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final totalItems = _getProjectsByFilter(statusFilter, projectProvider).length;
    final totalPages = (totalItems / _itemsPerPage).ceil();
    
    if (_currentPages[statusFilter]! < totalPages) {
      setState(() {
        _currentPages[statusFilter] = _currentPages[statusFilter]! + 1;
      });
    }
  }

  void _goToPreviousPage(String statusFilter) {
    if (_currentPages[statusFilter]! > 1) {
      setState(() {
        _currentPages[statusFilter] = _currentPages[statusFilter]! - 1;
      });
    }
  }

  List<ProjectListItem> _getProjectsByFilter(String statusFilter, ProjectProvider projectProvider) {
    if (statusFilter == "PROSES_VERIFIKASI") {
      return projectProvider.getProjectsByStatuses([
        'PROSES VERIFIKASI',
        'REVISI',
        'APPROVAL',
        'TTD KONTRAK',
        'DITOLAK',
      ], newest: _sortIndex == 0);
    } else if (statusFilter == "BERJALAN") {
      final allProjects = projectProvider.userProjects;
      var projects = allProjects
          .where(
            (p) =>
                p.status == 'BERJALAN' ||
                p.status.startsWith('BERJALAN SIKLUS'),
          )
          .toList();

      if (_sortIndex == 0) {
        projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        projects.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
      return projects;
    } else {
      return projectProvider.getProjectsByStatus(
        statusFilter,
        newest: _sortIndex == 0,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    final userRole = authProvider.userRole ?? 'BASIC';
    final isPlatinum = userRole == 'PLATINUM';
    final homeRoute = isPlatinum ? '/member-platinum' : '/member-reguler';

    // Count projects by status
    final pendanaanDibukaCount = projectProvider.getProjectCountByStatus(
      'PENDANAAN DIBUKA',
    );
    final berjalanCount = projectProvider.userProjects
        .where(
          (p) =>
              p.status == 'BERJALAN' || p.status.startsWith('BERJALAN SIKLUS'),
        )
        .length;
    final selesaiCount = projectProvider.getProjectCountByStatus('SELESAI');
    final dibatalkanCount = projectProvider.getProjectCountByStatus(
      'DIBATALKAN',
    );
    final draftCount = projectProvider.getProjectCountByStatus('DRAFT');
    final prosesVerifikasiCount = projectProvider.getProjectCountByStatuses([
      'PROSES VERIFIKASI',
      'REVISI',
      'APPROVAL',
      'TTD KONTRAK',
      'DITOLAK',
    ]);

    return WillPopScope(
      onWillPop: () async {
        if (widget.fromProjectList) {
          Navigator.pop(context);
          return false;
        }
        Navigator.pushReplacementNamed(context, homeRoute);
        return false;
      },
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3FFFA),
          bottomNavigationBar: (isPlatinum && widget.fromProjectList)
              ? null
              : AppBottomNav(
                  currentIndex: 1,
                  onItemSelected: (i) {
                    if (i == 1) return;
                    if (!mounted) return;
                    switch (i) {
                      case 0:
                        Navigator.pushReplacementNamed(context, homeRoute);
                        break;
                      case 2:
                        Navigator.pushReplacementNamed(context, '/wallet');
                        break;
                      case 3:
                        Navigator.pushReplacementNamed(context, '/profile');
                        break;
                    }
                  },
                ),
          body: SafeArea(
            child: Column(
              children: [
                // Header + Tabs
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              widget.fromProjectList ? 56 : 24,
                              15,
                              10,
                              2,
                            ),
                            child: Text(
                              "Proyek Saya",
                              style: GoogleFonts.poppins(
                                fontSize: _deviceWidth * 0.07,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (widget.fromProjectList)
                            Positioned(
                              left: 0,
                              top: 12,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                iconSize: 20,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.green,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        onTap: (index) {
                          // Reset halaman ke 1 saat pindah tab
                          final filters = [
                            'PROSES_VERIFIKASI',
                            'PENDANAAN DIBUKA',
                            'BERJALAN',
                            'SELESAI',
                            'DIBATALKAN',
                            'DRAFT'
                          ];
                          setState(() {
                            _currentPages[filters[index]] = 1;
                          });
                        },
                        tabs: [
                          Tab(
                            child: Column(
                              children: [
                                const Text("Proses Verifikasi"),
                                const SizedBox(height: 4),
                                Text(
                                  "($prosesVerifikasiCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const Text("Pendanaan Dibuka"),
                                const SizedBox(height: 4),
                                Text(
                                  "($pendanaanDibukaCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const Text("Proyek Berjalan"),
                                const SizedBox(height: 4),
                                Text(
                                  "($berjalanCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const Text("Proyek Selesai"),
                                const SizedBox(height: 4),
                                Text(
                                  "($selesaiCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const Text("Proyek Dibatalkan"),
                                const SizedBox(height: 4),
                                Text(
                                  "($dibatalkanCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const Text("Draft Proyek"),
                                const SizedBox(height: 4),
                                Text(
                                  "($draftCount)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: _deviceHeight * 0.01),

                // Sort (Terbaru/Terlama)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _sortIndex = 0;
                              // Reset semua halaman ke 1
                              _currentPages.updateAll((key, value) => 1);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: Text(
                              "Terbaru",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _sortIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: _sortIndex == 0
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: _deviceHeight * 0.02,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _sortIndex = 1;
                              // Reset semua halaman ke 1
                              _currentPages.updateAll((key, value) => 1);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: _deviceHeight * 0.015,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Terlama",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _sortIndex == 1
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: _sortIndex == 1
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info banner
                if (projectProvider.status == ProjectStatus.loading)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orangeAccent.withOpacity(0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_rounded, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pembuatan proyek sedang diproses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Anda bisa melanjutkan aktivitas, status akan diperbarui otomatis.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Content area
                Expanded(
                  child: projectProvider.isLoadingProjects
                      ? const Center(child: CircularProgressIndicator())
                      : projectProvider.projectsError != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  projectProvider.projectsError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refreshProjects,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : TabBarView(
                          children: [
                            _buildProjectList("PROSES_VERIFIKASI"),
                            _buildProjectList("PENDANAAN DIBUKA"),
                            _buildProjectList("BERJALAN"),
                            _buildProjectList("SELESAI"),
                            _buildProjectList("DIBATALKAN"),
                            _buildProjectList("DRAFT"),
                          ],
                        ),
                ),

                // Button Buat Proyek Baru
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(_deviceHeight * 0.015),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: _deviceHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          _deviceHeight * 0.01,
                        ),
                      ),
                    ),
                    onPressed: () {
                      final provider = context.read<ProjectProvider>();
                      provider.clearEditMode();
                      provider.clearFormData();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProjectPage(),
                        ),
                      ).then((_) => _refreshProjects());
                    },
                    child: const Text(
                      "Buat Proyek Baru",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectList(String statusFilter) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    // Get all projects
    List<ProjectListItem> allProjects = _getProjectsByFilter(statusFilter, projectProvider);

    if (allProjects.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada proyek",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Calculate pagination
    final currentPage = _currentPages[statusFilter] ?? 1;
    final totalPages = (allProjects.length / _itemsPerPage).ceil();
    final startIndex = (currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, allProjects.length);
    final paginatedProjects = allProjects.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshProjects,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
                vertical: MediaQuery.of(context).size.height * 0.015,
              ),
              itemCount: paginatedProjects.length,
              itemBuilder: (context, index) {
                final project = paginatedProjects[index];

                return MyProjectCard(
                  projectId: project.id,
                  imageUrl: project.mainImageUrl,
                  status: project.statusDisplay,
                  title: project.judul,
                  tokenDitawarkan: project.tokenDitawarkan,
                  minBeli: project.minBeli,
                  sisaHari: project.sisaHari,
                  isDraft: project.isDraft,
                  onTap: () {
                    if (project.isDraft) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProjectPage(
                            isEditingDraft: true,
                            draftData: _convertProjectToMap(project),
                          ),
                        ),
                      ).then((_) => _refreshProjects());
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailPage(
                            projectId: project.id,
                            imageUrl: project.mainImageUrl,
                            status: project.statusDisplay,
                            title: project.judul,
                            owner: project.user.name,
                            remainingDays: project.sisaHari,
                            maxToken: project.tokenDitawarkan,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
        // Pagination widget
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: PaginationWidget(
              currentPage: currentPage,
              totalPages: totalPages,
              onNext: () => _goToNextPage(statusFilter),
              onPrevious: () => _goToPreviousPage(statusFilter),
            ),
          ),
      ],
    );
  }

  Map<String, dynamic> _convertProjectToMap(ProjectListItem project) {
    return {
      'id': project.id,
      'id_kategori': project.idKategori,
      'judul': project.judul,
      'deskripsi': project.deskripsi,
      'nominal': project.nominal,
      'asset_jaminan': project.assetJaminan,
      'nilai_jaminan': project.nilaiJaminan,
      'lokasi_usaha': project.lokasiUsaha,
      'detail_lokasi': project.detailLokasi,
      'pendapatan_perbulan': project.pendapatanPerbulan,
      'pengeluaran_perbulan': project.pengeluaranPerbulan,
      'limit_siklus': project.limitSiklus,
      'bagian_pelaksana': 0,
      'bagian_koperasi': 0,
      'bagian_pemilik': 0,
      'bagian_pendana': 0,
      'brosur_produk': project.brosurProduk,
      'dokumen_proyeksi': project.dokumenProyeksi,
    };
  }
}