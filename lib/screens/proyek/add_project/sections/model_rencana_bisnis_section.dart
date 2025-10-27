import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class ModelRencanaBisnisSection extends StatelessWidget {
  const ModelRencanaBisnisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            
            // Lokasi Usaha
            CustomTextFormField(
              label: 'Lokasi Usaha',
              hint: 'Cth. Jakarta',
              maxLines: 1,
              validator: _required,
              initialValue: provider.formData['lokasi_usaha'],
              onChanged: (value) => provider.updateFormData('lokasi_usaha', value),
            ),
            const SizedBox(height: 18),

            // Detail Lokasi
            CustomTextFormField(
              label: 'Detail Lokasi Tempat Usaha',
              hint: 'Detail Lokasi (Nama Jalan, No. Rumah, Blok/Unit No., Patokan)',
              maxLines: 4,
              validator: _required,
              initialValue: provider.formData['detail_lokasi'],
              onChanged: (value) => provider.updateFormData('detail_lokasi', value),
            ),
            const SizedBox(height: 22),

            // Brosur Katalog Produk (Optional)
            FileUploadForm(
              label: 'Brosur Katalog Produk (Opsional)',
              descriptions: const ['Maksimum size file 10 MB.'],
              maxFileSizeMB: 10,
              onFilePicked: (file) {
                if (file != null) {
                  provider.setBrosurProdukFile(file);
                }
              },
            ),
            const SizedBox(height: 22),

            // Pendapatan per bulan
            CustomTextFormField(
              label: 'Pendapatan Per Bulan',
              hint: 'Rp',
              keyboardType: TextInputType.number,
              validator: _required,
              initialValue: provider.formData['pendapatan_perbulan']?.toString(),
              onChanged: (value) => provider.updateFormData('pendapatan_perbulan', value),
            ),
            const SizedBox(height: 18),

            // Pengeluaran per bulan
            CustomTextFormField(
              label: 'Pengeluaran Per Bulan',
              hint: 'Rp',
              keyboardType: TextInputType.number,
              validator: _required,
              initialValue: provider.formData['pengeluaran_perbulan']?.toString(),
              onChanged: (value) => provider.updateFormData('pengeluaran_perbulan', value),
            ),
            const SizedBox(height: 22),

            // Dokumen Proyeksi Proyek (required)
            FileUploadForm(
              label: 'Dokumen Proyeksi Proyek',
              descriptions: const [
                'Silakan unduh contoh dokumen di sini: Dokumen Proyeksi Proyek',
                'Maksimum size file 10 MB.',
              ],
              maxFileSizeMB: 10,
              onFilePicked: (file) {
                if (file != null) {
                  provider.setDokumenProyeksiFile(file);
                }
              },
            ),
            const SizedBox(height: 18),

            // Siklus
            CustomTextFormField(
              label: 'Siklus (x siklus)',
              hint: 'Cth. 2',
              keyboardType: TextInputType.number,
              validator: _required,
              initialValue: provider.formData['limit_siklus']?.toString(),
              onChanged: (value) => provider.updateFormData('limit_siklus', value),
            ),
          ],
        );
      },
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;