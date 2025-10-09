import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';

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
              SizedBox(height: _deviceHeight * 0.015),
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
                    style: TextStyle(
                      fontSize: _deviceWidth * 0.045,
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
                      backgroundColor: Colors.green,
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
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.028,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      minFontSize: 9,
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
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Container(
          width: _deviceWidth,
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.05,
            vertical: _deviceHeight * 0.025,
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
                          style: TextStyle(
                            fontSize: _deviceWidth * 0.065,
                            fontWeight: FontWeight.w800,
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
                                style: TextStyle(
                                  fontSize: _deviceWidth * 0.042,
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
                                      : Colors.orange,
                                ),
                              ),
                              child: Text(
                                isPremium ? "Member Premium" : "Member Reguler",
                                style: TextStyle(
                                  fontSize: _deviceWidth * 0.028,
                                  color:
                                      isPremium ? Colors.white : Colors.orange,
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
              SizedBox(height: _deviceHeight * 0.025),

              // Card Ringkasan Saldo
              Row(
                children: [
                  _buildSummaryCard("Simpanan Pokok", "Rp 50.000"),
                  SizedBox(width: _deviceWidth * 0.025),
                  _buildSummaryCard("Simpanan Wajib", "Rp 120.000"),
                ],
              ),
              SizedBox(height: _deviceHeight * 0.02),

              // Banner join penyertaan
              _buildPenyertaanBanner(),
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
          horizontal: _deviceWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(
                fontSize: _deviceWidth * 0.03,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _deviceHeight * 0.008),
            AutoSizeText(
              amount,
              style: TextStyle(
                fontSize: _deviceWidth * 0.045,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPenyertaanBanner() {
    return Container(
      width: double.infinity,
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
              Container(
                padding: EdgeInsets.all(_deviceWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  "assets/icons/join_penyertaan.png",
                  width: _deviceWidth * 0.07,
                  height: _deviceWidth * 0.07,
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
                        style: TextStyle(
                          fontSize: _deviceWidth * 0.036,
                          fontWeight: FontWeight.w600,
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
                      style: TextStyle(
                        fontSize: _deviceWidth * 0.032,
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
                backgroundColor: Colors.orange,
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
                style: TextStyle(
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
