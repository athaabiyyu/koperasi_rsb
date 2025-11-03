import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-proses-verifikasi.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/models/payment-member_model.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/utils/currency_helper.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  final int? nominalPenyertaan;
  final bool isTopUpOnly;
  final bool isSimpananWajib;
  final bool isPenyertaan; // ✅ Flag baru untuk penyertaan

  const KonfirmasiPembayaran({
    Key? key,
    this.nominalPenyertaan,
    this.isTopUpOnly = false,
    this.isSimpananWajib = false,
    this.isPenyertaan = false, // ✅ Default false
  }) : super(key: key);

  @override
  State<KonfirmasiPembayaran> createState() => _KonfirmasiPembayaranState();
}

class _KonfirmasiPembayaranState extends State<KonfirmasiPembayaran> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _rekeningController = TextEditingController();
  String? _selectedBank;
  File? _buktiPembayaran;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _rekeningController.dispose();
    super.dispose();
  }

  void _handleFilePicked(dynamic file) {
    if (file != null && file.path != null) {
      setState(() {
        _buktiPembayaran = File(file.path);
      });
      print('File bukti pembayaran yang dipilih: ${file.path}');
    }
  }

  // ✅ Submit payment dengan logic berbeda berdasarkan flag
  Future<void> _handleSubmitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_buktiPembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap upload bukti pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedBank == null || _selectedBank!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih bank'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final topupProvider = Provider.of<TopupProvider>(context, listen: false);

      Map<String, dynamic> result;

      // ✅ Cek prioritas: simpanan wajib > penyertaan > top-up > registrasi
      if (widget.isSimpananWajib) {
        print('💰 CALLING SIMPANAN WAJIB ENDPOINT');

        final token = authProvider.token;

        if (token == null || token.isEmpty) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token tidak valid. Silakan login kembali.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        result = await topupProvider.submitSimpananWajib(
          token: token,
          namaBank: _selectedBank!,
          noRekening: _rekeningController.text.trim(),
          namaPemilikRekening: _namaController.text.trim(),
          buktiPembayaran: _buktiPembayaran!,
        );
      } else if (widget.isPenyertaan) {
        // ✅ PENYERTAAN: Upgrade to Platinum (hanya nominal penyertaan)
        print('🌟 CALLING UPGRADE TO PLATINUM ENDPOINT');

        final token = authProvider.token;

        if (token == null || token.isEmpty) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token tidak valid. Silakan login kembali.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final nominal = widget.nominalPenyertaan ?? 0;
        if (nominal <= 0) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nominal penyertaan tidak valid'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final paymentModel = PaymentModel(
          namaBank: _selectedBank!,
          noRekening: _rekeningController.text.trim(),
          namaPemilikRekening: _namaController.text.trim(),
          buktiPembayaran: _buktiPembayaran!,
        );

        result = await authProvider.upgradeToPlatinum(
          paymentModel,
          nominal,
        );
      } else if (widget.isTopUpOnly) {
        // Top-up biasa
        print('⚡ CALLING TOP-UP ENDPOINT');

        final token = authProvider.token;

        if (token == null || token.isEmpty) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token tidak valid. Silakan login kembali.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final nominal = widget.nominalPenyertaan ?? 0;
        if (nominal <= 0) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nominal top-up tidak valid'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        result = await topupProvider.submitTopup(
          token: token,
          namaBank: _selectedBank!,
          noRekening: _rekeningController.text.trim(),
          namaPemilikRekening: _namaController.text.trim(),
          nominal: nominal,
          buktiPembayaran: _buktiPembayaran!,
        );
      } else {
        // Registrasi dengan/tanpa upgrade platinum
        final paymentModel = PaymentModel(
          namaBank: _selectedBank!,
          noRekening: _rekeningController.text.trim(),
          namaPemilikRekening: _namaController.text.trim(),
          buktiPembayaran: _buktiPembayaran!,
        );

        if (widget.nominalPenyertaan != null && widget.nominalPenyertaan! > 0) {
          print('📝 CALLING REGISTER + UPGRADE PLATINUM ENDPOINT');
          result = await authProvider.registerPayAndUpgradePlatinum(
            paymentModel,
            widget.nominalPenyertaan!,
          );
        } else {
          print('📝 CALLING REGISTER + PAY ENDPOINT');
          result = await authProvider.registerAndPay(paymentModel);
        }
      }

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success'] == true) {
        String title;
        String description;

        // ✅ Handle success message berdasarkan tipe transaksi
        if (widget.isSimpananWajib) {
          title = "Pembayaran Simpanan Wajib Sedang Diproses";
          description =
              "Pembayaran simpanan wajib Anda sedang diverifikasi oleh Admin. "
              "Tunggu hingga 2x24 jam.\n\n"
              "Saldo simpanan wajib akan bertambah setelah admin mengkonfirmasi pembayaran Anda.";
        } else if (widget.isPenyertaan) {
          // ✅ Success message untuk penyertaan
          title = "Upgrade Platinum Sedang Diproses";
          description =
              "Penyertaan modal Anda sedang diverifikasi oleh Admin. "
              "Tunggu hingga 2x24 jam.\n\n"
              "Setelah admin menerima, status akun Anda akan diupgrade ke Platinum "
              "dan saldo penyertaan akan ditambahkan.";
        } else if (widget.isTopUpOnly) {
          title = "Top-Up Sedang Diproses";
          description = "Top-up Anda sedang diverifikasi oleh Admin. "
              "Tunggu hingga 2x24 jam.\n\n"
              "Saldo akan bertambah setelah admin mengkonfirmasi pembayaran Anda.";
        } else if (widget.nominalPenyertaan != null &&
            widget.nominalPenyertaan! > 0) {
          title = "Akun Dalam Proses Upgrade";
          description =
              "Registrasi dan upgrade platinum Anda sedang diproses oleh Admin. "
              "Tunggu hingga 2x24 jam.\n\n"
              "Setelah admin menerima, Anda akan menerima kode OTP via WhatsApp untuk aktivasi akun.";
        } else {
          title = "Akun Dalam Proses Verifikasi";
          description = "Akun Anda sedang diverifikasi oleh Admin. "
              "Tunggu hingga 2x24 jam.\n\n"
              "Setelah admin menerima, Anda akan menerima kode OTP via WhatsApp untuk aktivasi akun.";
        }

        showCustomDialog(
          context: context,
          title: title,
          description: description,
          imagePath: "assets/images/ava-proses-verifikasi.png",
          buttonText: "Saya Mengerti",
          onButtonPressed: () {
            Navigator.of(context).pop();

            // ✅ Navigate berbeda berdasarkan tipe transaksi
            if (widget.isSimpananWajib || widget.isTopUpOnly || widget.isPenyertaan) {
              // Kembali ke dashboard/wallet untuk member yang sudah login
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/wallet',
                (Route<dynamic> route) => false,
              );
            } else {
              // Kembali ke login untuk registrasi baru
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (Route<dynamic> route) => false,
              );
            }
          },
          bottomText: "Butuh bantuan? Hubungi Admin",
          onBottomTextTap: () {
            print("User klik Hubungi Admin");
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Terjadi kesalahan'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (widget.isTopUpOnly || widget.isPenyertaan)
          ? AppBar(
              title: Text(
                widget.isPenyertaan
                    ? 'Konfirmasi Penyertaan'
                    : 'Konfirmasi Top-Up',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Konfirmasi Pembayaran",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: secGrayFont,
                          thickness: 0.2,
                          height: 20,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ✅ Info box dengan pesan sesuai tipe transaksi
                      if (widget.nominalPenyertaan != null &&
                          widget.nominalPenyertaan! > 0)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: lightGreen,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.isSimpananWajib
                                ? 'Nominal simpanan wajib: Rp 120.000'
                                : widget.isPenyertaan
                                    ? 'Nominal penyertaan modal: ${CurrencyUtils.formatRupiah(widget.nominalPenyertaan!)}'
                                    : widget.isTopUpOnly
                                        ? 'Nominal top-up: ${CurrencyUtils.formatRupiah(widget.nominalPenyertaan!)}'
                                        : 'Anda akan di-upgrade ke Platinum dengan nominal penyertaan: ${CurrencyUtils.formatRupiah(widget.nominalPenyertaan!)}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      if (widget.nominalPenyertaan != null &&
                          widget.nominalPenyertaan! > 0)
                        const SizedBox(height: 20),

                      // Form fields
                      CustomTextFormField(
                        controller: _namaController,
                        label: "Atas Nama",
                        hint: "Cth. Rofid",
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Atas nama wajib diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      CustomTextFormField(
                        controller: _rekeningController,
                        label: "No. Rekening Anda",
                        hint: "Cth. 6328-19292-1029",
                        keyboardType: TextInputType.number,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor rekening wajib diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      CustomDropdownFormField(
                        label: "Bank yang digunakan",
                        hint: "Pilih bank",
                        items: const ["BANK MANDIRI", "BRI", "BCA", "BNI"],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Pilih bank terlebih dahulu";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedBank = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),

                      FileUploadForm(
                        label: 'Bukti Pembayaran',
                        descriptions: const [
                          '• Upload bukti transfer',
                          '• Maksimal size 10 MB',
                        ],
                        maxFileSizeMB: 10,
                        onFilePicked: _handleFilePicked,
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: SizedBox(
                          width: deviceWidth * 0.75,
                          height: 55,
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: darkGreen,
                                  ),
                                )
                              : CustomButton(
                                  text: "KONFIRMASI PEMBAYARAN",
                                  onPressed: _handleSubmitPayment,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}