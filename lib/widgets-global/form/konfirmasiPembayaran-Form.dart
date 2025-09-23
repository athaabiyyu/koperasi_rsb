import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-proses-verifikasi.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class KonfirmasiPembayaranForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;

  const KonfirmasiPembayaranForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<KonfirmasiPembayaranForm> createState() =>
      _KonfirmasiPembayaranFormState();
}

class _KonfirmasiPembayaranFormState extends State<KonfirmasiPembayaranForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _rekeningController = TextEditingController();
  String? _selectedBank;
  PlatformFile? _buktiPembayaran;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Card
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
              // Atas Nama
              CustomTextFormField(
                label: "Atas Nama",
                hint: "Cth. Rofid",
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
                label: "No. Rekening Anda",
                hint: "Cth. 6328-19292-1029",
                keyboardType: TextInputType.number,
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

              // Upload Bukti
              FileUploadForm(
                label: 'Bukti Pembayaran',
                descriptions: const [
                  '• Upload bukti transfer',
                  '• Maksimal size 10 MB',
                ],
                maxFileSizeMB: 10,
                onFilePicked: (file) {
                  setState(() {
                    _buktiPembayaran = file;
                  });
                  print('File yang dipilih: ${file?.name}');
                },
              ),
              const SizedBox(height: 30),

              // Tombol Konfirmasi
              Center(
                child: SizedBox(
                  width: deviceWidth * 0.75,
                  height: 55,
                  child: CustomButton(
                    text: "KONFIRMASI PEMBAYARAN",
                    onPressed: () {
                      // dialog proses verifikasi

                      // showCustomDialog(
                      //   context: context,
                      //   title: "Akun Dalam Proses Verifikasi",
                      //   description:
                      //       "Akun Anda sedang diverifikasi. Tunggu hingga 2x24 jam.\nJika belum ada konfirmasi, silakan hubungi Admin.",
                      //   imagePath: "assets/images/ava-proses-verifikasi.png",
                      //   buttonText: "Hubungi Admin",
                      //   onButtonPressed: () {
                      //     print("User klik Hubungi Admin");
                      //   },
                      // );

                      // dialog otp
                      showCustomDialog(
                        context: context,
                        description:
                            "Silahkan Masukkan Kode OTP yang telah kami kirim",
                        imagePath: "assets/images/ava-payment.png",
                        showOtpFields: true,
                        otpLength: 4,
                        buttonText: "Masuk",
                        onButtonPressed: () {
                          print("User klik Masuk");
                        },
                        bottomText:
                            "OTP error atau tidak menerima OTP? Chat Admin",
                        onBottomTextTap: () {
                          print("User klik Chat Admin");
                        },
                      );

                      // dialog biasa

                      // showCustomDialog(
                      //   context: context,
                      //   title: "Akun Anda Telah Diverifikasi",
                      //   description:
                      //       "Kami telah mengirimkan Kode OTP ke Nomor Whatsapp Anda. Silakan periksa dan masukkan kode Otp Setelah ini untuk menyelesaikan proses Registrasi.",
                      //   imagePath: "assets/images/ava-proses-diverifikasi.png",
                      //   buttonText: "MASUK",
                      //   onButtonPressed: () {
                      //     print("User Berhasil Login");
                      //   },
                      // );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
