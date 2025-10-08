import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class ProyekSection extends StatelessWidget {
  final String? initialJudul;
  final String? initialKategori;
  final String? initialDeskripsi;

  const ProyekSection({
    super.key,
    this.initialJudul,
    this.initialKategori,
    this.initialDeskripsi,
  });

  @override
  Widget build(BuildContext context) {
    const categories = ['Pertanian', 'Peternakan', 'Perdagangan'];

    final String? safeKategori = categories.contains(initialKategori)
        ? initialKategori
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          label: 'Judul Proyek',
          hint: 'Cth. Ayam goreng Ana',
          validator: _required,
          initialValue: initialJudul,
        ),
        const SizedBox(height: 18),
        CustomDropdownFormField(
          label: 'Kategori Proyek',
          hint: 'Kategori Proyek',
          items: categories,
          validator: _requiredValue,
          value: safeKategori,
        ),
        const SizedBox(height: 18),
        CustomTextFormField(
          label: 'Deskripsi',
          hint: 'Tuliskan deskripsi proyek anda:',
          maxLines: 6,
          validator: _required,
          initialValue: initialDeskripsi,
        ),
        const SizedBox(height: 22),
        const FileUploadForm(
          label: 'Dokumen Pendukung (Foto Toko, NPWP, dsb)',
          maxFileSizeMB: 10,
          descriptions: [
            'Contoh: foto produk, NPWP, foto toko, slide pitch deck, dsb.',
            'Maksimum size file 10 MB.',
          ],
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
String? _requiredValue(dynamic v) => (v == null) ? 'Wajib dipilih' : null;
