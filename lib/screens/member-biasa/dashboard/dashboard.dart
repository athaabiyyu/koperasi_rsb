import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/transaction-item.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart'; 
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
    _loadTopupHistory();
  }

  Future<void> _loadTopupHistory() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final topupProvider = Provider.of<TopupProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      await topupProvider.fetchTopupHistory(authProvider.token!);
    }
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final topupProvider = Provider.of<TopupProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      await topupProvider.refreshTopupHistory(authProvider.token!);
    }
  }

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
    final topupProvider = Provider.of<TopupProvider>(context);
    
    final userName = userProvider.userName ?? 'User';
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
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeaderSection(userName, isplatinum),
                SizedBox(height: _deviceHeight * 0.045),
                _buildTransactionHistoryCard(topupProvider),
                SizedBox(height: _deviceHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTransactionHistoryCard(TopupProvider topupProvider) {
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
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: AutoSizeText(
                  "Riwayat Transaksi",
                  style: GoogleFonts.poppins(
                    fontSize: _deviceWidth * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  minFontSize: 14,
                ),
              ),
              SizedBox(width: _deviceWidth * 0.02),
              if (topupProvider.pendingTopup != null)
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      padding: EdgeInsets.symmetric(
                        horizontal: _deviceWidth * 0.025,
                        vertical: _deviceHeight * 0.008,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final pendingTopup = topupProvider.pendingTopup!;
                      DetailPembayaranAwalMember.show(
                        context,
                        alertTitle: "Detail Pembayaran",
                        alertMessage: "Pastikan data pembayaran sudah benar.",
                        paymentTitle: "Pembayaran Top Up",
                        paymentHeader: "Informasi Pembayaran",
                        paymentItems: [
                          PaymentItem(
                            // ✅ FIXED: Gunakan displayTransactionType
                            title: pendingTopup.displayTransactionType,
                            price: pendingTopup.displayAmount,
                          ),
                        ],
                        totalPrice: pendingTopup.displayAmount,
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pembayaran dikonfirmasi"),
                            ),
                          );
                          _refreshData();
                        },
                      );
                    },
                    child: AutoSizeText(
                      "Bayar Top Up",
                      style: GoogleFonts.poppins(
                        fontSize: _deviceWidth * 0.032,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      minFontSize: 11,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: _deviceHeight * 0.015),
          const Divider(height: 1),
          SizedBox(height: _deviceHeight * 0.01),
          
          // Loading State
          if (topupProvider.isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
                child: const CircularProgressIndicator(),
              ),
            )
          
          // Error State
          else if (topupProvider.errorMessage != null)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: _deviceHeight * 0.02),
                    Text(
                      topupProvider.errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: _deviceHeight * 0.02),
                    ElevatedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Empty State
          else if (!topupProvider.hasTopups)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: _deviceHeight * 0.02),
                    Text(
                      "Belum ada riwayat transaksi",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Transaction List
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topupProvider.topups.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final topup = topupProvider.topups[index];
                
                // ✅ DEBUG: Print untuk melihat data setiap transaksi
                print('🔍 Transaction $index:');
                print('  - Type: ${topup.displayTransactionType}');
                print('  - Jenis: ${topup.jenis}');
                print('  - Status: ${topup.displayStatus}');
                
                // ✅ Gunakan TransactionItemEnhanced untuk support semua status
                return TransactionItemEnhanced(
                  title: topup.displayTransactionType,
                  date: topup.displayDate,
                  amount: topup.displayAmount,
                  status: topup.status, // Pass raw status untuk logic icon
                  statusLabel: topup.displayStatus,
                );
              },
            ),
        ],
      ),
    ),
  );
}

  Widget _buildHeaderSection(String userName, bool isplatinum) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.46),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Container(
          width: _deviceWidth,
          padding: EdgeInsets.only(
            left: _deviceWidth * 0.07,
            right: _deviceWidth * 0.07,
            top: _deviceHeight * 0.045,
            bottom: _deviceHeight * 0.050,
          ),
          color: lightGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        SizedBox(height: _deviceHeight * 0.008),
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
              SizedBox(height: _deviceHeight * 0.065),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          icon: Icons.savings_rounded,
                          title: "Simpanan Wajib",
                          amount: "Rp 120.000",
                          color: Colors.blue.shade400,
                        ),
                      ),
                      SizedBox(width: _deviceWidth * 0.025),
                      Expanded(
                        child: _buildSummaryCard(
                          icon: Icons.trending_up_rounded,
                          title: "Sisa Hasil Usaha",
                          amount: "Rp 0",
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _deviceHeight * 0.02),
                  _buildSummaryCard(
                    icon: Icons.account_balance_wallet_rounded,
                    title: "Simpanan Pokok",
                    amount: "Rp 50.000",
                    color: Colors.green.shade400,
                  ),
                  SizedBox(height: _deviceHeight * 0.045),
                ],
              ),
              _buildPenyertaanBanner(isplatinum),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        showSummaryDialog(
          icon: icon,
          title: title,
          amount: amount,
          color: color,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      amount,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      padding: EdgeInsets.all(_deviceWidth * 0.055),
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
              Container(
                padding: EdgeInsets.all(_deviceWidth * 0.02),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  "assets/icons/join_penyertaan.png",
                  width: _deviceWidth * 0.09,
                  height: _deviceWidth * 0.09,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: _deviceWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isplatinum) ...[
                      AutoSizeText(
                        "Ingin Mengikuti Penyertaan?",
                        style: GoogleFonts.poppins(
                          fontSize: _deviceWidth * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        minFontSize: 12,
                      ),
                      SizedBox(height: _deviceHeight * 0.008),
                    ],
                    AutoSizeText(
                      isplatinum
                          ? "Top up saldo minimal dimulai dari Rp500.000"
                          : "Nikmati Keistimewaan Hanya dengan minimal Rp 500.000",
                      style: GoogleFonts.poppins(
                        fontSize: _deviceWidth * 0.030,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      minFontSize: 11,
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
                backgroundColor: orange,
                padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
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
                isplatinum ? "Top Up Penyertaan" : "Join Penyertaan",
                style: GoogleFonts.poppins(
                  fontSize: _deviceWidth * 0.038,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                minFontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}