import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/screens/proyek/project_detail.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';

class PremiumDashboardPage extends StatefulWidget {
  const PremiumDashboardPage({Key? key}) : super(key: key);

  @override
  State<PremiumDashboardPage> createState() => _PremiumDashboardPageState();
}

class _PremiumDashboardPageState extends State<PremiumDashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  // Removed local isPremium flag; use role from AuthProvider instead.

  final List<Map<String, dynamic>> _tokenUsage = const [
    {
      'title': 'Stand Telur Gulung',
      'owner': 'Budi Wijaya',
      'status': 'Proyek Berjalan',
      'modal': 10,
      'hasil': 2,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/telur/600/400',
    },
    {
      'title': 'Stand Pisang Nugget',
      'owner': 'Marlina Siahaan',
      'status': 'Proyek Selesai',
      'modal': 20,
      'hasil': 20,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/pisang/600/400',
    },
    {
      'title': 'Stand Crepes Azzura',
      'owner': 'Marlina Siahaan',
      'status': 'Proyek Berjalan',
      'modal': 20,
      'hasil': 7,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/crepes/600/400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName ?? 'User';
    final userRole = authProvider.userRole ?? 'BASIC';
    final isplatinum = userRole == 'PLATINUM';

    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (i) {
          if (!mounted) return;
          switch (i) {
            case 0:
              if (ModalRoute.of(context)?.settings.name != '/member-premium') {
                Navigator.pushReplacementNamed(context, '/member-premium');
              }
              break;
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
              SizedBox(height: _deviceHeight * 0.03),

              _buildTokenUsageSection(),
              SizedBox(height: _deviceHeight * 0.02),
              _buildTransactionHistoryCard(),
              SizedBox(height: _deviceHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String userName, bool isplatinum) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Dashboard',
                          style: GoogleFonts.poppins(
                            fontSize: _deviceWidth * 0.065,
                            fontWeight: FontWeight.w800,
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
                                isplatinum
                                    ? 'Member Platinum'
                                    : 'Member Reguler',
                                style: GoogleFonts.poppins(
                                  fontSize: _deviceWidth * 0.028,
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
                    backgroundImage: const AssetImage(
                      'assets/images/avatar.jpg',
                    ),
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

  Widget _buildTokenUsageSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Penggunaan Token',
                style: GoogleFonts.poppins(
                  fontSize: _deviceWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/member-premium/token-usage');
                },
                child: Text(
                  'Lihat lainnya',
                  style: GoogleFonts.poppins(
                    color: darkGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _deviceHeight * 0.008),
          Builder(
            builder: (context) {
              // Responsive list/card height based on device height
              final double listHeight = (_deviceHeight * 0.24)
                  .clamp(180, 230)
                  .toDouble();
              return SizedBox(
                height: listHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tokenUsage.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: _deviceWidth * 0.035),
                  itemBuilder: (context, index) {
                    final item = _tokenUsage[index];
                    final isSelesai = (item['status'] as String).contains(
                      'Selesai',
                    );
                    return _TokenUsageCard(
                      title: item['title'],
                      owner: item['owner'],
                      status: item['status'],
                      modal: item['modal'],
                      hasil: item['hasil'],
                      modalLabel: item['modalLabel'],
                      hasilLabel: item['hasilLabel'],
                      cardHeight: listHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailPage(
                              imageUrl: item['imageUrl'],
                              status: item['status'],
                              title: item['title'],
                              owner: item['owner'],
                              collectedToken: item['hasil'],
                              remainingDays: isSelesai ? 0 : 12,
                              maxToken: item['modal'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    'Riwayat Transaksi',
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
                        alertTitle: 'Detail Pembayaran',
                        alertMessage: 'Pastikan data pembayaran sudah benar.',
                        paymentTitle: 'Pembayaran Simpanan Wajib',
                        paymentHeader: 'Informasi Pembayaran',
                        paymentItems: [
                          PaymentItem(
                            title: 'Simpanan Wajib',
                            price: 'Rp 120.000',
                          ),
                        ],
                        totalPrice: 'Rp 120.000',
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pembayaran Simpanan Wajib dikonfirmasi',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: AutoSizeText(
                      'Bayar Simpanan Wajib',
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
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2025',
              amount: 'Rp. 120.000',
              isSuccess: false,
              statusLabel: 'Belum Membayar',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Pokok',
              date: '12 Agustus 2024',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2023',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2023',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2023',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2023',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
            const Divider(),
            const TransactionItem(
              title: 'Simpanan Wajib',
              date: '12 Agustus 2023',
              amount: 'Rp. 120.000',
              isSuccess: true,
              statusLabel: 'Berhasil',
            ),
          ],
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
                  'assets/icons/join_penyertaan.png',
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
                        'Ingin Mengikuti Penyertaan?',
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
                          ? 'Top up saldo minimal dimulai dari Rp500.000'
                          : 'Nikmati Keistimewaan Hanya dengan minimal Rp 500.000',
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
                padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.015),
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
                isplatinum ? 'Top Up Penyertaan' : 'Join Penyertaan',
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

class _TokenUsageCard extends StatelessWidget {
  final String title;
  final String owner;
  final String status;
  final int modal;
  final int hasil;
  final String modalLabel;
  final String hasilLabel;
  final double cardHeight;
  final VoidCallback onTap;

  const _TokenUsageCard({
    Key? key,
    required this.title,
    required this.owner,
    required this.status,
    required this.modal,
    required this.hasil,
    required this.modalLabel,
    required this.hasilLabel,
    required this.cardHeight,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const double radius = 12;
    // const double gapS = 8; // no longer used
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double gapM = (deviceHeight * 0.012).clamp(8.0, 14.0).toDouble();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: width * 0.74,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          constraints: BoxConstraints(
            minHeight: cardHeight,
            maxHeight: cardHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Owner + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Spacer(),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status.contains('Selesai')
                              ? Colors.green.withOpacity(0.12)
                              : Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: status.contains('Selesai')
                                ? darkGreen
                                : Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: gapM),

              // Title
              AutoSizeText(
                title,
                maxLines: 2,
                minFontSize: 11,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),
              Text(
                owner,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: gapM),

              // Metrics block: two bordered stat boxes
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$modal',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jumlah Penggunaan Token',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Rp 0',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: darkGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            'Return: ($hasil)',
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
