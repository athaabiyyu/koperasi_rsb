import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/card-muncul-rekening.dart';
import 'package:koperasi_rsb/widgets-global/form/form-konfirmasi-pembayaran.dart'
    as form_konfirmasi;
import 'package:koperasi_rsb/widgets-global/reusable-page/pembayaran-section.dart';
import 'package:koperasi_rsb/utils/currency_helper.dart';

class MunculRekeningMemberBiasa extends StatefulWidget {
  final int? nominalPenyertaan;
  final int? totalPembayaran;
  final String? formattedNominal;
  final bool isTopUpOnly;
  final bool isSimpananWajib;
  final bool isPenyertaan;

  const MunculRekeningMemberBiasa({
    Key? key,
    this.nominalPenyertaan,
    this.totalPembayaran,
    this.formattedNominal,
    this.isSimpananWajib = false,
    this.isTopUpOnly = false,
    this.isPenyertaan = false,
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

  // ✅ Method untuk generate rincian title
  String _getRincianTitle() {
    if (widget.isSimpananWajib) {
      return 'Rincian Pembayaran Simpanan Wajib:';
    } else if (widget.isPenyertaan) {
      return 'Rincian Penyertaan Modal:';
    } else if (widget.isTopUpOnly) {
      return 'Rincian Top-Up:';
    } else {
      return 'Rincian Pembayaran:';
    }
  }

  // ✅ Method untuk generate list rincian items
  List<RincianItem> _getRincianItems() {
    List<RincianItem> items = [];

    if (widget.isSimpananWajib) {
      // Hanya simpanan wajib 120.000
      items.add(RincianItem(label: 'Simpanan Wajib', value: 'Rp 120.000'));
    } else if (widget.isPenyertaan) {
      // Penyertaan: hanya nominal penyertaan
      items.add(RincianItem(
        label: 'Penyertaan Modal',
        value: widget.formattedNominal ?? 'Rp 0',
      ));
    } else if (widget.isTopUpOnly) {
      // Top-up biasa: hanya nominal top-up
      items.add(RincianItem(
        label: 'Nominal Top-Up',
        value: widget.formattedNominal ?? 'Rp 0',
      ));
    } else {
      // Registrasi: Setoran Awal + Simpanan Wajib + Penyertaan
      items.add(RincianItem(label: 'Setoran Awal', value: 'Rp 50.000'));
      items.add(RincianItem(label: 'Simpanan Wajib', value: 'Rp 120.000'));
      items.add(RincianItem(
        label: 'Penyertaan Modal',
        value: widget.formattedNominal ?? 'Rp 0',
      ));
    }

    return items;
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

                const SizedBox(height: 20),

                // ✅ Card rekening bank dengan rincian pembayaran di dalamnya
                CardPembayaranBank(
                  bankName: "BRI",
                  bankLogo: "assets/logo/bri-logo.png",
                  noRekening: "372 178 5022",
                  namaPemilik: "Koperasi Produksi Rejeki Sukses Berkah",
                  totalPembayaran: CurrencyUtils.formatRupiah(
                    widget.isSimpananWajib
                        ? 120000
                        : widget.totalPembayaran ??
                            (widget.isPenyertaan || widget.isTopUpOnly
                                ? widget.nominalPenyertaan ?? 0
                                : 170000),
                  ),
                  // ✅ Kirim rincian jika nominal ada
                  rincianTitle: (widget.nominalPenyertaan != null &&
                          widget.nominalPenyertaan! > 0)
                      ? _getRincianTitle()
                      : null,
                  rincianItems: (widget.nominalPenyertaan != null &&
                          widget.nominalPenyertaan! > 0)
                      ? _getRincianItems()
                      : null,
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
}