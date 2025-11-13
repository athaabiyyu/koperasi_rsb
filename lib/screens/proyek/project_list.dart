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

  class ProjectListPage extends StatefulWidget {
    const ProjectListPage({super.key});

    @override
    State<ProjectListPage> createState() => _ProjectListPageState();
  }

  class _ProjectListPageState extends State<ProjectListPage> {
    final TextEditingController _searchController = TextEditingController();
    Timer? _debounce;
    String _viewMode = 'grid'; // 'grid', 'list', 'masonry'

    @override
    void initState() {
      super.initState();
      _loadViewMode(); // Load saved view mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProjectProvider>().loadAllProjects(
          status: 'PENDANAAN DIBUKA',
        );
      });
    }

    // Load view mode dari SharedPreferences
    Future<void> _loadViewMode() async {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString('project_view_mode') ?? 'grid';
      setState(() {
        _viewMode = savedMode;
      });
    }

    // Save view mode ke SharedPreferences
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
      });
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
                    // Search bar dengan shadow
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
                                    setState(() {});
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
                              _buildViewModeButton(
                                icon: Icons.dashboard,
                                mode: 'masonry',
                                isSelected: _viewMode == 'masonry',
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

            // Project List with different layouts
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
                final projects = provider.allProjects;
                if (projects.isEmpty) {
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

                // Different layout based on view mode
                if (_viewMode == 'list') {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final p = projects[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.04,
                            vertical: 6,
                          ),
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
                      childCount: projects.length,
                    ),
                  );
                } else if (_viewMode == 'masonry') {
                  // Staggered grid (masonry style)
                  return SliverPadding(
                    padding: EdgeInsets.all(deviceWidth * 0.02),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72, // Slightly taller cards
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = projects[index];
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
                        childCount: projects.length,
                      ),
                    ),
                  );
                } else {
                  // Default grid view with better spacing
                  return SliverPadding(
                    padding: EdgeInsets.all(deviceWidth * 0.03),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: deviceWidth * 0.03,
                        mainAxisSpacing: deviceHeight * 0.02,
                        childAspectRatio: 0.71,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = projects[index];
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
                        childCount: projects.length,
                      ),
                    ),
                  );
                }
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
          });
          _saveViewMode(mode); // Save ke SharedPreferences
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