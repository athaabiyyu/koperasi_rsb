// kode 7
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
import 'package:provider/provider.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  final int? nominalPenyertaan;

  const KonfirmasiPembayaran({
    Key? key,
    this.nominalPenyertaan,
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
    print('=== KONFIRMASI PEMBAYARAN INIT ===');
    print('Nominal Penyertaan: ${widget.nominalPenyertaan}');
    print('==================================');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _rekeningController.dispose();
    super.dispose();
  }

  // Handle file picked
  void _handleFilePicked(dynamic file) {
    if (file != null && file.path != null) {
      setState(() {
        _buktiPembayaran = File(file.path);
      });
      print('File bukti pembayaran yang dipilih: ${file.path}');
    }
  }

  // Submit payment
  Future<void> _handleSubmitPayment() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate file upload
    if (_buktiPembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap upload bukti pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate bank selection
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

      // Create payment model
      final paymentModel = PaymentModel(
        namaBank: _selectedBank!,
        noRekening: _rekeningController.text.trim(),
        namaPemilikRekening: _namaController.text.trim(),
        buktiPembayaran: _buktiPembayaran!,
      );

      print('=== SUBMITTING REGISTRATION & PAYMENT ===');
      print('Payment Model: $paymentModel');
      print('Nominal Penyertaan: ${widget.nominalPenyertaan}');
      print('=========================================');

      // PENTING: Gunakan method berbeda bergantung ada nominal penyertaan atau tidak
      final result = widget.nominalPenyertaan != null && widget.nominalPenyertaan! > 0
          ? await authProvider.registerPayAndUpgradePlatinum(
              paymentModel,
              widget.nominalPenyertaan!,
            )
          : await authProvider.registerAndPay(paymentModel);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        // Show success dialog - waiting for admin confirmation
        showCustomDialog(
          context: context,
          title: widget.nominalPenyertaan != null && widget.nominalPenyertaan! > 0
              ? "Akun Dalam Proses Upgrade"
              : "Akun Dalam Proses Verifikasi",
          description: widget.nominalPenyertaan != null && widget.nominalPenyertaan! > 0
              ? "Registrasi dan upgrade platinum Anda sedang diproses oleh Admin. Tunggu hingga 2x24 jam.\n\nSetelah admin menerima, Anda akan menerima kode OTP via WhatsApp untuk aktivasi akun."
              : "Akun Anda sedang diverifikasi oleh Admin. Tunggu hingga 2x24 jam.\n\nSetelah admin menerima, Anda akan menerima kode OTP via WhatsApp untuk aktivasi akun.",
          imagePath: "assets/images/ava-proses-verifikasi.png",
          buttonText: "Saya Mengerti",
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog

            // Navigate to login page
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (Route<dynamic> route) => false,
            );
          },
          bottomText: "Butuh bantuan? Hubungi Admin",
          onBottomTextTap: () {
            print("User klik Hubungi Admin");
            // TODO: Implement chat admin functionality
          },
        );
      } else {
        // Show error message
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
                      // Header
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

                      // Info jika ada penyertaan
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
                            'Anda akan di-upgrade ke Platinum dengan nominal penyertaan: ${_formatRupiah(widget.nominalPenyertaan!)}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      if (widget.nominalPenyertaan != null &&
                          widget.nominalPenyertaan! > 0)
                        const SizedBox(height: 20),

                      // Atas Nama
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

                      // No. Rekening
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

                      // Dropdown Bank
                      CustomDropdownFormField(
                        label: "Bank yang digunakan",
                        hint: "Pilih bank",
                        items: const [
                          "BANK MANDIRI",
                          "BRI",
                          "BCA",
                          "BNI"
                        ],
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

                      // Upload Bukti
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

                      // Tombol Konfirmasi
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