import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropdownFormField.dart';
import 'package:google_fonts/google_fonts.dart';

class AlamatPage extends StatefulWidget {
  const AlamatPage({super.key});
  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  final _formKey = GlobalKey<FormState>();
  final _detail = TextEditingController(text: 'Jl. Mawar No. 123');
  String? _provinsi = 'Jawa Timur';
  String? _kota = 'Surabaya';
  String? _kecamatan = 'Genteng';

  final _listProvinsi = const ['Jawa Timur', 'Jawa Tengah', 'Jawa Barat'];
  final _listKota = const ['Surabaya', 'Sidoarjo', 'Gresik'];
  final _listKecamatan = const ['Genteng', 'Tegalsari', 'Wonokromo'];

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: const Text('Alamat'),
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
                  CustomDropdownFormField(
                    label: 'Provinsi',
                    hint: 'Pilih Provinsi',
                    value: _provinsi,
                    items: _listProvinsi,
                    onChanged: (v) {
                      setState(() => _provinsi = v);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Pilih provinsi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomDropdownFormField(
                    label: 'Kota / Kabupaten',
                    hint: 'Pilih Kota/Kabupaten',
                    value: _kota,
                    items: _listKota,
                    onChanged: (v) {
                      setState(() => _kota = v);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Pilih kota';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomDropdownFormField(
                    label: 'Kecamatan',
                    hint: 'Pilih Kecamatan',
                    value: _kecamatan,
                    items: _listKecamatan,
                    onChanged: (v) {
                      setState(() => _kecamatan = v);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Pilih kecamatan';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextFormField(
                    label: 'Detail Alamat',
                    hint: 'Nama jalan, RT/RW, patokan',
                    controller: _detail,
                    maxLines: 3,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      return null;
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
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alamat disimpan')));
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
