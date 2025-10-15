import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart'; 

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

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: lightGreen,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Default User';
    final userRole = authProvider.userRole ?? 'BASIC';
    final isplatinum = userRole == 'PLATINUM';

    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (i) {
          if (i == 0) return;
          if (!mounted) return;
          switch (i) {
            case 1:
              Navigator.pushReplacementNamed(context, '/my-project');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(userName, isplatinum),
              SizedBox(height: _deviceHeight * 0.05),
              _buildTransactionHistoryCard(),
              SizedBox(height: _deviceHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistoryCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(_deviceWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AutoSizeText(
                "Riwayat Transaksi",
                style: GoogleFonts.poppins(
                  fontSize: _deviceWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                minFontSize: 16,
              ),
            ),
            SizedBox(height: _deviceHeight * 0.015),
            const Divider(height: 1),
            SizedBox(height: _deviceHeight * 0.01),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2025",
              amount: "Rp. 120.000",
              isSuccess: false,
              statusLabel: "Belum Membayar",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Pokok",
              date: "12 Agustus 2024",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2023",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2023",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2023",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2023",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
            const Divider(),
            const TransactionItem(
              title: "Simpanan Wajib",
              date: "12 Agustus 2023",
              amount: "Rp. 120.000",
              isSuccess: true,
              statusLabel: "Berhasil",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String userName, bool isplatinum) {
    return Container(
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.46),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: _deviceWidth,
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan nama, status, dan foto profil
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "Dashboard",
                            style: GoogleFonts.poppins(
                              fontSize: _deviceWidth * 0.07,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            minFontSize: 20,
                          ),
                          SizedBox(height: _deviceHeight * 0.01),
                          Row(
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  userName,
                                  style: GoogleFonts.poppins(
                                    fontSize: _deviceWidth * 0.02,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: _deviceWidth * 0.02),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _deviceWidth * 0.025,
                                  vertical: _deviceHeight * 0.004,
                                ),
                                decoration: BoxDecoration(
                                  color: isplatinum
                                      ? Colors.green
                                      : const Color(0xFFFFF0E6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isplatinum
                                        ? Colors.green.shade700
                                        : orange,
                                  ),
                                ),
                                child: Text(
                                  isplatinum ? "Member Platinum" : "Member Reguler",
                                  style: GoogleFonts.poppins(
                                    fontSize: _deviceWidth * 0.020,
                                    color: isplatinum ? Colors.white : orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: _deviceWidth * 0.03),
                    CircleAvatar(
                      radius: _deviceWidth * 0.08,
                      backgroundImage:
                          const AssetImage("assets/images/avatar.jpg"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Card Total Saldo
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(_deviceWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Saldo",
                          style: GoogleFonts.poppins(
                            fontSize: _deviceWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showSummaryDialog(
                              icon: Icons.trending_up_rounded,
                              title: "Sisa Hasil Usaha",
                              amount: "Rp 0",
                              color: orange,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(_deviceWidth * 0.02),
                            decoration: BoxDecoration(
                              color: orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.trending_up_rounded,
                              color: orange,
                              size: _deviceWidth * 0.06,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _deviceHeight * 0.005),
                    Text(
                      "Rp 170.000",
                      style: GoogleFonts.poppins(
                        fontSize: _deviceWidth * 0.08,
                        fontWeight: FontWeight.w700,
                        color: darkGreen,
                      ),
                    ),
                    SizedBox(height: _deviceHeight * 0.005),
                    Text(
                      "Simpanan: Rp 50.000",
                      style: GoogleFonts.poppins(
                        fontSize: _deviceWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: _deviceHeight * 0.05),
                    
                    // Tombol Bayar Simpanan dan Join Penyertaan
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              padding: EdgeInsets.symmetric(
                                vertical: _deviceHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              DetailPembayaranAwalMember.show(
                                context,
                                alertTitle: "Detail Pembayaran",
                                alertMessage: "Pastikan data pembayaran sudah benar.",
                                paymentTitle: "Pembayaran Simpanan Wajib",
                                paymentHeader: "Informasi Pembayaran",
                                paymentItems: [
                                  PaymentItem(
                                      title: "Simpanan Wajib", price: "Rp 120.000"),
                                ],
                                totalPrice: "Rp 120.000",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Pembayaran Simpanan Wajib dikonfirmasi")),
                                  );
                                },
                              );
                            },
                            child: AutoSizeText(
                              "Bayar Simpanan",
                              style: GoogleFonts.poppins(
                                fontSize: _deviceWidth * 0.032,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: _deviceWidth * 0.03),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              padding: EdgeInsets.symmetric(
                                vertical: _deviceHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              showDialogJoinPenyertaan(
                                context: context,
                                onJoin: () {
                                  showDialogPilihNominalPembayaran(context);
                                },
                                onCancel: () {},
                              );
                            },
                            child: AutoSizeText(
                              isplatinum ? "Top Up" : "Join Penyertaan",
                              style: GoogleFonts.poppins(
                                fontSize: _deviceWidth * 0.032,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: _deviceHeight * 0.03),
              
              // Banner Penyertaan
              _buildPenyertaanBanner(isplatinum),
            ],
          ),
        ),
      ),
    );
  }

  void showSummaryDialog({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 42),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Tutup",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenyertaanBanner(bool isplatinum) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_deviceWidth * 0.025),
            decoration: BoxDecoration(
              color: orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              "assets/icons/join_penyertaan.png",
              width: _deviceWidth * 0.1,
              height: _deviceWidth * 0.1,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: _deviceWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isplatinum)
                  AutoSizeText(
                    "Ingin Mengikuti Penyertaan?",
                    style: GoogleFonts.poppins(
                      fontSize: _deviceWidth * 0.035,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    minFontSize: 13,
                  ),
                SizedBox(height: _deviceHeight * 0.003),
                AutoSizeText(
                  isplatinum
                      ? "Top up saldo minimal dimulai dari Rp500.000"
                      : "Nikmati Keistimewaan Hanya dengan minimal Rp 500.000",
                  style: GoogleFonts.poppins(
                    fontSize: _deviceWidth * 0.028,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  minFontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}