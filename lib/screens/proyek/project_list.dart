import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/card/project_list_card.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/screens/proyek/my_project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koperasi_rsb/widgets-global/navigation/pagination_table.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _viewMode = 'grid';
  int _currentPage = 1;
  final int _itemsPerPage = 4; 

  @override
  void initState() {
    super.initState();
    _loadViewMode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadAllProjects(
        status: 'PENDANAAN DIBUKA',
      );
    });
  }

  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('project_view_mode') ?? 'grid';
    setState(() {
      _viewMode = savedMode;
    });
  }

  Future<void> _saveViewMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('project_view_mode', mode);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      final query = value.trim();
      context.read<ProjectProvider>().loadAllProjects(
        search: query.isEmpty ? null : query,
        status: 'PENDANAAN DIBUKA',
      );
      // Reset ke halaman 1 saat search
      setState(() {
        _currentPage = 1;
      });
    });
  }

  void _goToNextPage(int totalPages) {
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyProjectPage(fromProjectList: true),
            ),
          );
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.folder, color: Colors.white),
        label: Text(
          'Proyek Saya',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onItemSelected: (i) {
          if (!mounted) return;
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/member-platinum');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/project-list');
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: lightGreen,
        elevation: 0,
        title: Text(
          "Daftar Proyek",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Search & Filter Section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(deviceWidth * 0.04),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        context.read<ProjectProvider>().loadAllProjects(
                          search: value.trim(),
                          status: 'PENDANAAN DIBUKA',
                        );
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari proyek...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                        suffixIcon: (_searchController.text.isNotEmpty)
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<ProjectProvider>().loadAllProjects(
                                    status: 'PENDANAAN DIBUKA',
                                  );
                                  setState(() {
                                    _currentPage = 1;
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {});
                        _onSearchChanged(val);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter & View Mode Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Filter button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.green.shade600),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.tune, color: Colors.green[600]),
                        label: Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // View mode selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildViewModeButton(
                              icon: Icons.grid_view,
                              mode: 'grid',
                              isSelected: _viewMode == 'grid',
                            ),
                            _buildViewModeButton(
                              icon: Icons.view_list,
                              mode: 'list',
                              isSelected: _viewMode == 'list',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Project List with pagination
          Consumer<ProjectProvider>(
            builder: (context, provider, _) {
              if (provider.isLoadingAllProjects) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (provider.allProjectsError != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            provider.allProjectsError!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              
              final allProjects = provider.allProjects;
              if (allProjects.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada proyek',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Calculate pagination
              final totalPages = (allProjects.length / _itemsPerPage).ceil();
              final startIndex = (_currentPage - 1) * _itemsPerPage;
              final endIndex = (startIndex + _itemsPerPage).clamp(0, allProjects.length);
              final paginatedProjects = allProjects.sublist(startIndex, endIndex);

              // Build layout based on view mode
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Projects display
                    if (_viewMode == 'list')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                          vertical: 6,
                        ),
                        itemCount: paginatedProjects.length,
                        itemBuilder: (context, index) {
                          final p = paginatedProjects[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ProjectListCard(
                              projectId: p.id,
                              imageUrl: p.mainImageUrl,
                              status: p.statusDisplay,
                              title: p.judul,
                              owner: p.user.name,
                              remainingDays: p.sisaHari,
                              maxToken: p.tokenDitawarkan,
                            ),
                          );
                        },
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.03),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: deviceWidth * 0.03,
                            mainAxisSpacing: deviceHeight * 0.02,
                            childAspectRatio: 0.71,
                          ),
                          itemCount: paginatedProjects.length,
                          itemBuilder: (context, index) {
                            final p = paginatedProjects[index];
                            return ProjectListCard(
                              projectId: p.id,
                              imageUrl: p.mainImageUrl,
                              status: p.statusDisplay,
                              title: p.judul,
                              owner: p.user.name,
                              remainingDays: p.sisaHari,
                              maxToken: p.tokenDitawarkan,
                            );
                          },
                        ),
                      ),

                    // Pagination widget dengan padding bawah untuk FAB
                    if (totalPages > 1)
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: 80, // Extra space untuk FAB
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PaginationWidget(
                          currentPage: _currentPage,
                          totalPages: totalPages,
                          onNext: () => _goToNextPage(totalPages),
                          onPrevious: _goToPreviousPage,
                        ),
                      )
                    else
                      // Space untuk FAB meskipun tidak ada pagination
                      const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton({
    required IconData icon,
    required String mode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _viewMode = mode;
          _currentPage = 1; // Reset ke halaman 1 saat ganti view mode
        });
        _saveViewMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}