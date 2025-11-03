import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/card/project_list_card.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Load initial projects from API via Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load projects dengan status PENDANAAN DIBUKA
      context.read<ProjectProvider>().loadAllProjects(
            status: 'PENDANAAN DIBUKA',
          );
    });
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
            status: 'PENDANAAN DIBUKA', // Tambahkan filter status
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: lightGreen,
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.04,
                vertical: _deviceHeight * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      context.read<ProjectProvider>().loadAllProjects(
                            search: value.trim(),
                            status: 'PENDANAAN DIBUKA',
                          );
                    },
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: (_searchController.text.isNotEmpty)
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<ProjectProvider>().loadAllProjects(
                                      status:
                                          'PENDANAAN DIBUKA', // Tambahkan filter status
                                    );
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: _deviceHeight * 0.012,
                        horizontal: 20,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {}); // update clear icon visibility
                      _onSearchChanged(val);
                    },
                  ),
                  SizedBox(height: _deviceHeight * 0.01),

                  // Filter button (placeholder)
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green),
                        padding: EdgeInsets.symmetric(
                          horizontal: _deviceWidth * 0.03,
                          vertical: _deviceHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.green,
                      ),
                      label: const Text(
                        "Filter",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Grid Project - consume provider data (ALL projects)
            Expanded(
              child: Consumer<ProjectProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoadingAllProjects) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.allProjectsError != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          provider.allProjectsError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  final projects = provider.allProjects;
                  if (projects.isEmpty) {
                    return const Center(child: Text('Belum ada proyek'));
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: _deviceWidth * 0.02,
                      vertical: _deviceHeight * 0.01,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: _deviceWidth * 0.02,
                      mainAxisSpacing: _deviceHeight * 0.015,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      return ProjectListCard(
                        projectId: p.id,
                        imageUrl: p.mainImageUrl,
                        status: p.statusDisplay,
                        title: p.judul,
                        owner: p.user.name,
                        collectedToken:
                            0, // TODO: map from funding data if available
                        remainingDays: p.sisaHari,
                        maxToken: p.tokenDitawarkan,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
