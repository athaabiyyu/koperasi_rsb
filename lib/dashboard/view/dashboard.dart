import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';

// TODO: MEMBUNKUS NAMA DAN STATUS MEMBER AGAR TIDAK OVERFLOW KE AREA AVATAR DAN MEMBATASI JUMLAH KATA/MENYINGKAT NAMA APABILA MEMILIKI JUMLAH KARAKTER YANG BANYAK.

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(),
            SizedBox(height: _deviceHeight * 0.01),
            // Card Riwayat Transaksi
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Judul + Tombol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: _deviceWidth * 0.01),
                          child: Text(
                            "Riwayat Transaksi",
                            style: TextStyle(
                              fontSize: _deviceWidth * 0.05,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: _deviceWidth * 0.03,
                              vertical: _deviceHeight * 0.001,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: AutoSizeText(
                            "Bayar Simpanan Wajib",
                            style: TextStyle(
                              fontSize: _deviceWidth * 0.025,
                              color: Colors.white,
                            ),
                            minFontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),

                    // List Transaksi + Divider antar item
                    Column(
                      children: [
                        TransactionItem(
                          title: "Simpanan Wajib",
                          date: "12 Agustus 2025",
                          amount: "Rp. 120.000",
                          isSuccess: false,
                          statusLabel: "Belum Membayar",
                        ),
                        const Divider(),
                        TransactionItem(
                          title: "Simpanan Pokok",
                          date: "12 Agustus 2024",
                          amount: "Rp. 120.000",
                          isSuccess: true,
                          statusLabel: "Berhasil",
                        ),
                        const Divider(),
                        TransactionItem(
                          title: "Simpanan Wajib",
                          date: "12 Agustus 2023",
                          amount: "Rp. 120.000",
                          isSuccess: true,
                          statusLabel: "Berhasil",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight * 0.02), // jarak ke bawah
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Container(
          width: _deviceWidth,
          padding: EdgeInsets.only(
            right: _deviceWidth * 0.05,
            left: _deviceWidth * 0.05,
            top: _deviceHeight * 0.03,
            bottom: _deviceHeight * 0.005,
          ),
          color: lightGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas: Nama, badge, avatar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: _deviceWidth * 0.06,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: _deviceHeight * 0.005),
                        Row(
                          children: [
                            AutoSizeText(
                              "Andi Hidayat",
                              style: TextStyle(
                                fontSize: _deviceWidth * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              
                            ),
                            SizedBox(width: _deviceWidth * 0.02),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth * 0.02,
                                vertical: _deviceHeight * 0.002,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0E6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Text(
                                "Member Reguler",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Avatar user
                  CircleAvatar(
                    radius: _deviceWidth * 0.08,
                    backgroundImage: const AssetImage("assets/avatar.png"),
                  ),
                ],
              ),

              SizedBox(height: _deviceHeight * 0.03),

              // Card Ringkasan Saldo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.008),
                child: Row(
                  children: [
                    _buildSummaryCard("Simpanan Pokok", "Rp 50.000"),
                    SizedBox(width: _deviceWidth * 0.02), // jarak antar card
                    _buildSummaryCard("Simpanan Wajib", "Rp 120.000"),
                    SizedBox(width: _deviceWidth * 0.02), // jarak antar card
                    // _buildSummaryCard("Sisa Hasil Usaha", "Rp 5.000.000"),
                  ],
                ),
              ),

              // Banner join penyertaan
              Container(
                width: _deviceWidth,
                padding: EdgeInsets.all(_deviceWidth * 0.03),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(_deviceWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon custom dari assets
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              "assets/icons/join_penyertaan.png",
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "Ingin Mengikuti Penyertaan?",
                                  style: TextStyle(
                                    fontSize: _deviceWidth * 0.03,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  minFontSize: 10,
                                ),
                                SizedBox(height: 12), // jarak antar teks
                                AutoSizeText(
                                  "Nikmati Keistimewaan Hanya dengan minimal Rp 500.000",
                                  style: TextStyle(
                                    fontSize: _deviceWidth * 0.03,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  minFontSize: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _deviceHeight * 0.015),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              vertical: _deviceHeight * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Join Penyertaan",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _deviceHeight * 0.015,
          horizontal: _deviceWidth * 0.025,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(
                fontSize: _deviceWidth * 0.027,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _deviceHeight * 0.01),
            AutoSizeText(
              amount,
              style: TextStyle(
                fontSize: _deviceWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(height: _deviceHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
