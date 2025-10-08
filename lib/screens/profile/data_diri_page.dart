import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:google_fonts/google_fonts.dart';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});
  @override
  State<DataDiriPage> createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  final _formKey = GlobalKey<FormState>();
  final _nik = TextEditingController(text: '3501234567890124');
  final _nama = TextEditingController(text: 'budiono siregar');
  final _hp = TextEditingController(text: '6281234567891');
  final _tempat = TextEditingController(text: 'Surabaya');
  final _tanggal = TextEditingController(text: '03/03/2003');

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2003, 3, 3),
        firstDate: DateTime(1950),
        lastDate: now,
        helpText: 'Pilih Tanggal Lahir');
    if (picked != null) {
      if (!mounted) return;
      _tanggal.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nik.dispose();
    _nama.dispose();
    _hp.dispose();
    _tempat.dispose();
    _tanggal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: const Text('Data Diri'),
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
                children: [
                  CustomTextFormField(
                    label: 'NIK',
                    hint: 'Nomor Induk Kependudukan',
                    controller: _nik,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      if (v.length != 16) return 'Harus 16 digit';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextFormField(
                    label: 'Nama Lengkap',
                    hint: 'Nama sesuai KTP',
                    controller: _nama,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextFormField(
                    label: 'No. Handphone',
                    hint: '08xxxxxxxx',
                    controller: _hp,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      if (v.length < 10) return 'Minimal 10 digit';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          label: 'Tempat Lahir',
                          hint: 'Kota',
                          controller: _tempat,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Wajib diisi';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                              label: 'Tanggal Lahir',
                              hint: 'DD/MM/YYYY',
                              controller: _tanggal,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Wajib diisi';
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Diri disimpan')));
                    }
                  },
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
