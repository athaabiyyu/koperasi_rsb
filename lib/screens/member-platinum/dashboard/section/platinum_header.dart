import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';

class PremiumHeader extends StatelessWidget {
  final String userName;
  final bool isplatinum;

  const PremiumHeader({
    super.key,
    required this.userName,
    required this.isplatinum,
  });

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

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
          width: deviceWidth,
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.05,
            vertical: deviceHeight * 0.025,
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
                            fontSize: deviceWidth * 0.065,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          minFontSize: 20,
                        ),
                        SizedBox(height: deviceHeight * 0.008),
                        Row(
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: deviceWidth * 0.042,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                minFontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.02),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.025,
                                vertical: deviceHeight * 0.004,
                              ),
                              decoration: BoxDecoration(
                                color: darkGreen,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: darkGreen),
                              ),
                              child: Text(
                                'Member Platinum',
                                style: GoogleFonts.poppins(
                                  fontSize: deviceWidth * 0.028,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.03),
                  CircleAvatar(
                    radius: deviceWidth * 0.08,
                    backgroundImage: const AssetImage(
                      'assets/images/avatar.jpg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.065),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          icon: Icons.savings_rounded,
                          title: 'Simpanan Wajib',
                          amount: 'Rp 120.000',
                          color: Colors.blue.shade400,
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.025),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          icon: Icons.trending_up_rounded,
                          title: 'Sisa Hasil Usaha',
                          amount: 'Rp 0',
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  _buildSummaryCard(
                    context,
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Simpanan Pokok',
                    amount: 'Rp 50.000',
                    color: Colors.green.shade400,
                  ),
                  SizedBox(height: deviceHeight * 0.045),
                ],
              ),
              _buildPenyertaanBanner(
                context,
                isplatinum,
                deviceHeight,
                deviceWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        _showSummaryDialog(
          context,
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

  void _showSummaryDialog(
    BuildContext context, {
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
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenyertaanBanner(
    BuildContext context,
    bool isplatinum,
    double deviceHeight,
    double deviceWidth,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.055),
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
                padding: EdgeInsets.all(deviceWidth * 0.02),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/icons/join_penyertaan.png',
                  width: deviceWidth * 0.09,
                  height: deviceWidth * 0.09,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: deviceWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isplatinum) ...[
                      AutoSizeText(
                        'Ingin Mengikuti Penyertaan?',
                        style: GoogleFonts.poppins(
                          fontSize: deviceWidth * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        minFontSize: 12,
                      ),
                      SizedBox(height: deviceHeight * 0.008),
                    ],
                    AutoSizeText(
                      isplatinum
                          ? 'Top up saldo minimal dimulai dari Rp500.000'
                          : 'Nikmati Keistimewaan Hanya dengan minimal Rp 500.000',
                      style: GoogleFonts.poppins(
                        fontSize: deviceWidth * 0.030,
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
          SizedBox(height: deviceHeight * 0.015),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.015),
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
                  fontSize: deviceWidth * 0.038,
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
