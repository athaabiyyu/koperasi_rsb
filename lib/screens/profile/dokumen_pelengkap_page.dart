import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class DokumenPelengkapPage extends StatefulWidget {
  const DokumenPelengkapPage({super.key});
  @override
  State<DokumenPelengkapPage> createState() => _DokumenPelengkapPageState();
}

class _DokumenPelengkapPageState extends State<DokumenPelengkapPage> {
  final _formKey = GlobalKey<FormState>();
  bool _ktpPicked = false;
  bool _fotoPicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: const Text('Dokumen Pelengkap'),
        backgroundColor: lightGreen,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _card(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FileUploadForm(
                    label: 'Foto KTP',
                    isRequired: true,
                    descriptions: const [
                      '• Upload foto KTP jelas dan asli',
                      '• Maksimum ukuran 10 MB'
                    ],
                    onFilePicked: (file) {
                      if (!mounted) return;
                      setState(() => _ktpPicked = file != null);
                    },
                  ),
                  const SizedBox(height: 18),
                  FileUploadForm(
                    label: 'Foto Diri',
                    isRequired: true,
                    descriptions: const [
                      '• Upload foto wajah jelas',
                      '• Maksimum ukuran 10 MB'
                    ],
                    onFilePicked: (file) {
                      if (!mounted) return;
                      setState(() => _fotoPicked = file != null);
                    },
                  ),
                ],
              )),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: (_ktpPicked && _fotoPicked)
                          ? Colors.green
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: (_ktpPicked && _fotoPicked)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Dokumen disimpan')));
                        }
                      : null,
                  child: Text('SIMPAN',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: strokeGray),
        ),
        child: child,
      );
}
