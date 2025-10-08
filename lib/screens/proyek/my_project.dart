import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/my_project_card.dart';
import 'package:koperasi_rsb/screens/proyek/add_project.dart';
import 'package:koperasi_rsb/screens/proyek/project_detail.dart';

class MyProjectPage extends StatefulWidget {
  const MyProjectPage({super.key});

  @override
  State<MyProjectPage> createState() => _MyProjectPageState();
}

class _MyProjectPageState extends State<MyProjectPage>
    with SingleTickerProviderStateMixin {
  int _sortIndex = 0; // 0 = Terbaru, 1 = Terlama

  // Contoh data dummy
  final List<Map<String, dynamic>> _projects = [
    {
      "imageUrl": "https://picsum.photos/200",
      "status": "Pendanaan Dibuka",
      "title":
          "Perkebunan Pisang Desa Bono, Pakel, Tulungagung, Jawa Timur, Indonesia, Asia Tenggara",
      "tokenDitawarkan": 1000,
      "minBeli": 100,
      "terkumpul": 500,
      "sisaHari": 12,
    },
    {
      "imageUrl": "https://picsum.photos/200",
      "status": "Proyek Berjalan",
      "title": "Perkebunan Jagung Desa Makmur, Jawa Barat",
      "tokenDitawarkan": 2000,
      "minBeli": 20,
      "terkumpul": 2000,
      "sisaHari": 0,
    },
    {
      "imageUrl": "https://picsum.photos/200",
      "status": "Proyek Selesai",
      "title": "Ternak Ayam Desa Rukun, Bali",
      "tokenDitawarkan": 1500,
      "minBeli": 150,
      "terkumpul": 1500,
      "sisaHari": 0,
    },
    {
      "imageUrl": "https://picsum.photos/200",
      "status": "Proyek Dibatalkan",
      "title": "Kebun Kopi Desa Sentosa, Sumatera",
      "tokenDitawarkan": 1200,
      "minBeli": 120,
      "terkumpul": 300,
      "sisaHari": 0,
    },
    {
      "imageUrl": "https://picsum.photos/200",
      "status": "Draft Proyek",
      "title": "Budidaya Ikan Lele Desa Harapan, Kalimantan",
      "tokenDitawarkan": 0,
      "minBeli": 0,
      "terkumpul": 0,
      "sisaHari": 0,
      "isDraft": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3FFFA),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * 0.04,
                  vertical: _deviceHeight * 0.02,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.green,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Proyek Saya",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab
              Container(
                color: Colors.white,
                child: const TabBar(
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.green,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 16),
                  tabs: [
                    Tab(
                      child: Column(
                        children: [
                          Text("Pendanaan Dibuka"),
                          SizedBox(height: 4),
                          Text(
                            "(1)",
                            style: TextStyle(
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
                          Text("Proyek Berjalan"),
                          SizedBox(height: 4),
                          Text(
                            "(0)",
                            style: TextStyle(
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
                          Text("Proyek Selesai"),
                          SizedBox(height: 4),
                          Text(
                            "(0)",
                            style: TextStyle(
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
                          Text("Proyek Dibatalkan"),
                          SizedBox(height: 4),
                          Text(
                            "(0)",
                            style: TextStyle(
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
                          Text("Draft Proyek"),
                          SizedBox(height: 4),
                          Text(
                            "(0)",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
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
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.015),
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

              // List Proyek sesuai tab
              Expanded(
                child: TabBarView(
                  children: [
                    _buildProjectList("Pendanaan Dibuka"),
                    _buildProjectList("Proyek Berjalan"),
                    _buildProjectList("Proyek Selesai"),
                    _buildProjectList("Proyek Dibatalkan"),
                    _buildProjectList("Draft Proyek"),
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
                      borderRadius: BorderRadius.circular(_deviceHeight * 0.01),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddProjectPage()),
                    );
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
    );
  }

  /// List builder dengan filter status
  Widget _buildProjectList(String statusFilter) {
    // Filter sesuai status
    List<Map<String, dynamic>> filteredProjects = _projects
        .where((project) => project["status"] == statusFilter)
        .toList();

    // Sort sesuai _sortIndex
    if (_sortIndex == 0) {
      filteredProjects = filteredProjects.reversed.toList(); // terbaru
    }

    if (filteredProjects.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada proyek",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.015,
      ),
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        return MyProjectCard(
          imageUrl: project["imageUrl"],
          status: project["status"],
          title: project["title"],
          tokenDitawarkan: project["tokenDitawarkan"],
          minBeli: project["minBeli"],
          terkumpul: project["terkumpul"],
          sisaHari: project["sisaHari"],
          isDraft: project["isDraft"] == true,
          onTap: () {
            final bool isDraft = project["isDraft"] == true;
            if (isDraft) {
              // Open AddProjectPage with draft prefill
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddProjectPage(isEditingDraft: true, draftData: project),
                ),
              );
            } else {
              // Open ProjectDetailPage for non-draft items
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectDetailPage(
                    imageUrl: project["imageUrl"],
                    status: project["status"],
                    title: project["title"],
                    owner: "Anda",
                    collectedToken: project["terkumpul"],
                    remainingDays: project["sisaHari"],
                    maxToken: project["tokenDitawarkan"],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
