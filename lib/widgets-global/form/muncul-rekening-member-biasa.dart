import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/form/form-konfirmasi-pembayaran.dart'
    as form_konfirmasi;
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';

class MunculRekeningMemberBiasa extends StatefulWidget {
  final int? nominalPenyertaan;
  final int? totalPembayaran;
  final String? formattedNominal;
  final bool isTopUpOnly;
  final bool isSimpananWajib;
  final bool isPenyertaan; // ✅ Flag baru untuk penyertaan

  const MunculRekeningMemberBiasa({
    Key? key,
    this.nominalPenyertaan,
    this.totalPembayaran,
    this.formattedNominal,
    this.isSimpananWajib = false,
    this.isTopUpOnly = false,
    this.isPenyertaan = false, // ✅ Default false
  }) : super(key: key);

  @override
  State<MunculRekeningMemberBiasa> createState() =>
      _MunculRekeningMemberBiasaState();
}

class _MunculRekeningMemberBiasaState extends State<MunculRekeningMemberBiasa> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PembayaranSection(
                  imagePath: 'assets/images/ava-payment.png',
                  text:
                      "Silahkan transfer ke nomor rekening berikut agar transaksi anda dapat segera kami proses",
                  alertTitle: "Informasi Penting !",
                  alertMessage:
                      "•   Selesaikan pembayaran di nomor rekening kami.\n"
                      "•   Mohon transfer sesuai jumlah hingga 3 digit terakhir.",
                ),

                // ✅ Tampilkan rincian pembayaran berdasarkan tipe transaksi
                if (widget.nominalPenyertaan != null &&
                    widget.nominalPenyertaan! > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: const Color(0xFF2E7D32), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isSimpananWajib
                              ? 'Rincian Pembayaran Simpanan Wajib:'
                              : widget.isPenyertaan
                                  ? 'Rincian Penyertaan Modal:' // ✅ Label untuk penyertaan
                                  : widget.isTopUpOnly
                                      ? 'Rincian Top-Up:'
                                      : 'Rincian Pembayaran:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ✅ Tampilkan item berbeda berdasarkan tipe transaksi
                        if (widget.isSimpananWajib) ...[
                          // Hanya simpanan wajib 120.000
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Simpanan Wajib',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Rp 120.000',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ] else if (widget.isPenyertaan) ...[
                          // ✅ Penyertaan: hanya nominal penyertaan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Penyertaan Modal',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                widget.formattedNominal ?? 'Rp 0',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ] else if (widget.isTopUpOnly) ...[
                          // Top-up biasa: hanya nominal top-up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nominal Top-Up',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                widget.formattedNominal ?? 'Rp 0',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Registrasi: Setoran Awal + Simpanan Wajib + Penyertaan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Setoran Awal',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Rp 50.000',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Simpanan Wajib',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Rp 120.000',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Penyertaan Modal',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                widget.formattedNominal ?? 'Rp 0',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const Divider(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _formatRupiah(widget.isSimpananWajib
                                  ? 120000
                                  : widget.totalPembayaran ??
                                      (widget.isPenyertaan || widget.isTopUpOnly
                                          ? widget.nominalPenyertaan ?? 0
                                          : 170000)),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Card rekening bank
                CardPembayaranBank(
                  bankName: "BRI",
                  bankLogo: "assets/logo/bri-logo.png",
                  noRekening: "372 178 5022",
                  namaPemilik: "Koperasi Produksi Rejeki Sukses Berkah",
                  totalPembayaran: _formatRupiah(widget.totalPembayaran ??
                      (widget.isPenyertaan || widget.isTopUpOnly
                          ? widget.nominalPenyertaan ?? 0
                          : 170000)),
                  onCopy: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor rekening berhasil disalin'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onKonfirmasi: () {
                    print('Navigate to KonfirmasiPembayaran');
                    print('Nominal: ${widget.nominalPenyertaan}');
                    print('Is Top Up Only: ${widget.isTopUpOnly}');
                    print('Is Penyertaan: ${widget.isPenyertaan}');

                    // ✅ Pass flag isPenyertaan ke halaman konfirmasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            form_konfirmasi.KonfirmasiPembayaran(
                          nominalPenyertaan: widget.nominalPenyertaan,
                          isTopUpOnly: widget.isTopUpOnly,
                          isSimpananWajib: widget.isSimpananWajib,
                          isPenyertaan: widget.isPenyertaan, 
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRupiah(int value) {
    final chars = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write('.');
      buffer.write(chars[i]);
    }
    return 'Rp ' + buffer.toString().split('').reversed.join();
  }
}