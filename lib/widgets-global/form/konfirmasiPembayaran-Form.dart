import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';

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
  String? _buktiPembayaranPath; // simpan path file upload

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

          // Upload Bukti
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload Bukti Pembayaran *",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  // TODO: implementasi file picker
                  setState(() {
                    _buktiPembayaranPath = "dummy-path/bukti.jpg";
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: strokeGray, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _buktiPembayaranPath == null
                              ? "Tarik file di sini atau klik untuk mengunggah"
                              : "File: ${_buktiPembayaranPath!.split('/').last}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Konfirmasi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_buktiPembayaranPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap upload bukti pembayaran"),
                      ),
                    );
                    return;
                  }

                  widget.onSubmit({
                    "atas_nama": _namaController.text,
                    "no_rekening": _rekeningController.text,
                    "bank": _selectedBank,
                    "bukti": _buktiPembayaranPath,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Konfirmasi Pembayaran",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
