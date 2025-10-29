import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/project_list_card.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
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
                  ),
                  SizedBox(height: _deviceHeight * 0.01),

                  // Filter button
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
            // Grid Project
            // Expanded(
            //   child: GridView.count(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: _deviceWidth * 0.02,
            //       vertical: _deviceHeight * 0.01,
            //     ),
            //     crossAxisCount: 2,
            //     crossAxisSpacing: _deviceWidth * 0.02,
            //     mainAxisSpacing: _deviceHeight * 0.015,
            //     childAspectRatio: 0.72, // (Card Size)
            //     children: const [
            //       ProjectListCard(
            //         imageUrl:
            //             "https://alat-ukur-indonesia.com/wp-content/uploads/Teknologi-Greenhouse-Untuk-Pertanian.png",
            //         status: "Pendanaan Dibuka",
            //         title: "Pendanaan Kolam Ikan Lele Bioflok",
            //         owner: "Marlina Siahaan",
            //         collectedToken: 75,
            //         remainingDays: 10,
            //         maxToken: 100,
            //       ),
            //       ProjectListCard(
            //         imageUrl:
            //             "https://dkpp.bulelengkab.go.id/uploads/konten/cara-budidaya-lele-dengan-sistem-bioflok-97.jpg",
            //         status: "Pendanaan Dibuka",
            //         title: "Greenhouse",
            //         owner: "Sigura Liche",
            //         collectedToken: 25,
            //         remainingDays: 7,
            //         maxToken: 50,
            //       ),
            //       ProjectListCard(
            //         imageUrl:
            //             "https://img-global.cpcdn.com/recipes/7da1ed7a3f0596f0/1200x630cq80/photo.jpg",
            //         status: "Pendanaan Dibuka",
            //         title: "Stand Pisang Nugget Pak Bahlil Komedian ",
            //         owner: "Marlina Siahaan",
            //         collectedToken: 10,
            //         remainingDays: 10,
            //         maxToken: 100,
            //       ),
            //       ProjectListCard(
            //         imageUrl:
            //             "https://alat-ukur-indonesia.com/wp-content/uploads/Teknologi-Greenhouse-Untuk-Pertanian.png",
            //         status: "Pendanaan Dibuka",
            //         title: "Greenhouse",
            //         owner: "Sigura Liche",
            //         collectedToken: 40,
            //         remainingDays: 3,
            //         maxToken: 50,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
