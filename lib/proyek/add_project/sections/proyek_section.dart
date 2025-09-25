import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class ProyekSection extends StatelessWidget {
  const ProyekSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CustomTextFormField(
          label: 'Judul Proyek',
          hint: 'Cth. Ayam goreng Ana',
          validator: _required,
        ),
        SizedBox(height: 18),
        CustomDropdownFormField(
          label: 'Kategori Proyek',
          hint: 'Kategori Proyek',
          items: ['Pertanian', 'Peternakan', 'Perdagangan'],
          validator: _requiredValue,
        ),
        SizedBox(height: 18),
        CustomTextFormField(
          label: 'Deskripsi',
          hint: 'Tuliskan deskripsi proyek anda:',
          maxLines: 6,
          validator: _required,
        ),
        SizedBox(height: 22),
        FileUploadForm(
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
