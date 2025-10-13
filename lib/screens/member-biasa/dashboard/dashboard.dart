import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  bool isPremium = false;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: lightGreen,
        statusBarIconBrightness:
            Brightness.dark,
      ),
    );

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
              _buildHeaderSection(),
              SizedBox(height: _deviceHeight * 0.045),
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
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul dan tombol
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
                      "Bayar Simpanan Wajib",
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
            // List Transaksi
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

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.46),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
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
              // Header dengan nama dan avatar
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
                        // Nama dan badge status
                        Row(
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                "Andi Hidayat",
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
                                color: isPremium
                                    ? Colors.green
                                    : const Color(0xFFFFF0E6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPremium
                                      ? Colors.green.shade700
                                      : orange,
                                ),
                              ),
                              child: Text(
                                isPremium ? "Member Premium" : "Member Reguler",
                                style: GoogleFonts.poppins(
                                  fontSize: _deviceWidth * 0.020,
                                  color: isPremium ? Colors.white : orange,
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

              // Card Ringkasan Saldo
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

              // Banner join penyertaan
              _buildPenyertaanBanner(),
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
              // ignore: deprecated_member_use
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
                // ignore: deprecated_member_use
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
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 42),
              ),
              const SizedBox(height: 16),

              // Judul
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),

              // Nominal
              Text(
                amount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),

              // Tombol tutup
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

  Widget _buildPenyertaanBanner() {
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
                  // ignore: deprecated_member_use
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
                    if (!isPremium) ...[
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
                      isPremium
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
                isPremium ? "Top Up Penyertaan" : "Join Penyertaan",
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
