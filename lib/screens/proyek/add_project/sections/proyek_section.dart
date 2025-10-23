import 'dart:io';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class ProyekSection extends StatelessWidget {
  final String? initialJudul;
  final String? initialKategori;
  final String? initialDeskripsi;

  // Controllers / callbacks to lift state up
  final TextEditingController? judulController;
  final TextEditingController? deskripsiController;
  final ValueChanged<String?>? onKategoriChanged;
  final ValueChanged<File?>? onDokumenPendukungPicked;

  const ProyekSection({
    super.key,
    this.initialJudul,
    this.initialKategori,
    this.initialDeskripsi,
    this.judulController,
    this.deskripsiController,
    this.onKategoriChanged,
    this.onDokumenPendukungPicked,
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
          controller: judulController,
          initialValue: judulController == null ? initialJudul : null,
        ),
        const SizedBox(height: 18),
        CustomDropdownFormField(
          label: 'Kategori Proyek',
          hint: 'Kategori Proyek',
          items: categories,
          validator: _requiredValue,
          value: safeKategori,
          onChanged: onKategoriChanged,
        ),
        const SizedBox(height: 18),
        CustomTextFormField(
          label: 'Deskripsi',
          hint: 'Tuliskan deskripsi proyek anda:',
          maxLines: 6,
          validator: _required,
          controller: deskripsiController,
          initialValue: deskripsiController == null ? initialDeskripsi : null,
        ),
        const SizedBox(height: 22),
        FileUploadForm(
          label: 'Dokumen Pendukung (Foto Toko, NPWP, dsb)',
          maxFileSizeMB: 10,
          descriptions: [
            'Contoh: foto produk, NPWP, foto toko, slide pitch deck, dsb.',
            'Maksimum size file 10 MB.',
          ],
          onFilePicked: onDokumenPendukungPicked,
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
String? _requiredValue(dynamic v) => (v == null) ? 'Wajib dipilih' : null;
