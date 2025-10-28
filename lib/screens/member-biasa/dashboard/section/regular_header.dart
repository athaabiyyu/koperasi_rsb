import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';

class RegularHeader extends StatelessWidget {
  final String userName;

  const RegularHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

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
          width: deviceWidth,
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Dashboard + Username
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
                            fontSize: deviceWidth * 0.07,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          minFontSize: 20,
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        Row(
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: deviceWidth * 0.02,
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
                                color: const Color(0xFFFFF0E6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: orange),
                              ),
                              child: Text(
                                'Member Reguler',
                                style: GoogleFonts.poppins(
                                  fontSize: deviceWidth * 0.020,
                                  color: orange,
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

              const SizedBox(height: 40),

              // Container Sisa Hasil Usaha
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(deviceWidth * 0.05),
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
                    // Header Row (Sisa Hasil Usaha + Info Button)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sisa Hasil Usaha',
                          style: GoogleFonts.poppins(
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showSummaryDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(deviceWidth * 0.02),
                            decoration: BoxDecoration(
                              color: darkGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: darkGreen,
                              size: deviceWidth * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: deviceHeight * 0.005),

                    // Nilai SHU
                    Text(
                      'Rp 0',
                      style: GoogleFonts.poppins(
                        fontSize: deviceWidth * 0.08,
                        fontWeight: FontWeight.w700,
                        color: darkGreen,
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.03),

                    // Tombol Bayar & Join
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              padding: EdgeInsets.symmetric(
                                vertical: deviceHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              DetailPembayaranAwalMember.show(
                                context,
                                alertTitle: 'Detail Pembayaran',
                                alertMessage:
                                    'Pastikan data pembayaran sudah benar.',
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
                              'Bayar Simpanan',
                              style: GoogleFonts.poppins(
                                fontSize: deviceWidth * 0.032,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.03),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              padding: EdgeInsets.symmetric(
                                vertical: deviceHeight * 0.015,
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
                                  showDialogPilihNominalPembayaran(
                                    context,
                                    isPenyertaan: true,
                                  );
                                },
                                onCancel: () {},
                              );
                            },
                            child: AutoSizeText(
                              'Join Penyertaan',
                              style: GoogleFonts.poppins(
                                fontSize: deviceWidth * 0.032,
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

              SizedBox(height: deviceHeight * 0.03),

              _buildPenyertaanBanner(deviceHeight, deviceWidth),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog informasi pembayaran wajib & pokok
  void _showSummaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header warna hijau lembut + icon info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: lightGreen.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: darkGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(14),
                      child: const Icon(
                        Icons.info_outline,
                        color: darkGreen,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Informasi Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: darkGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Card detail pembayaran wajib
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.credit_card,
                                  color: Colors.green),
                              const SizedBox(width: 10),
                              Text(
                                'Simpanan Wajib',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Rp 120.000',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Card detail pembayaran pokok
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.savings, color: orange),
                              const SizedBox(width: 10),
                              Text(
                                'Simpanan Pokok',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: orange,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Rp 50.000',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: darkGreen,
                  ),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenyertaanBanner(double deviceHeight, double deviceWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.04),
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
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              color: orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/icons/join_penyertaan.png',
              width: deviceWidth * 0.1,
              height: deviceWidth * 0.1,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: deviceWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'Ingin Mengikuti Penyertaan?',
                  style: GoogleFonts.poppins(
                    fontSize: deviceWidth * 0.035,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  minFontSize: 13,
                ),
                SizedBox(height: deviceHeight * 0.003),
                AutoSizeText(
                  'Nikmati Keistimewaan Hanya dengan minimal Rp 500.000',
                  style: GoogleFonts.poppins(
                    fontSize: deviceWidth * 0.028,
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
