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

            // ✅ Brosur Katalog Produk dengan preview existing
            _buildSingleFileUpload(
              context: context,
              provider: provider,
              label: 'Brosur Katalog Produk (Opsional)',
              formDataKey: 'brosur_produk',
              currentFile: provider.brosurProdukFile,
              onFilePicked: (file) {
                if (file != null) {
                  provider.setBrosurProdukFile(file);
                }
              },
              onRemoveExisting: () {
                provider.updateFormData('brosur_produk', null);
              },
              onRemoveNew: () {
                provider.setBrosurProdukFile(null);
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

            // ✅ Dokumen Proyeksi Proyek dengan preview existing
            _buildSingleFileUpload(
              context: context,
              provider: provider,
              label: 'Dokumen Proyeksi Proyek',
              formDataKey: 'dokumen_proyeksi',
              currentFile: provider.dokumenProyeksiFile,
              isRequired: true,
              onFilePicked: (file) {
                if (file != null) {
                  provider.setDokumenProyeksiFile(file);
                }
              },
              onRemoveExisting: () {
                provider.updateFormData('dokumen_proyeksi', null);
              },
              onRemoveNew: () {
                provider.setDokumenProyeksiFile(null);
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

  // ✅ Widget helper untuk single file upload dengan preview existing
  Widget _buildSingleFileUpload({
    required BuildContext context,
    required ProjectProvider provider,
    required String label,
    required String formDataKey,
    required dynamic currentFile,
    required Function(dynamic) onFilePicked,
    required VoidCallback onRemoveExisting,
    required VoidCallback onRemoveNew,
    bool isRequired = false,
  }) {
    // Cek apakah ada existing file dari server
    final existingFileUrl = provider.formData[formDataKey]?.toString();
    final hasExistingFile = existingFileUrl != null && existingFileUrl.isNotEmpty;
    
    // Cek apakah ada new file yang diupload
    final hasNewFile = currentFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // ✅ Tampilkan existing file (dari server)
        if (hasExistingFile && !hasNewFile) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3B82F6)),
            ),
            child: Row(
              children: [
                // File icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.cloud_done,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        existingFileUrl.split('/').last,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'File tersimpan',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Delete button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemoveExisting,
                  color: Colors.red[400],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Button untuk ganti file
          TextButton.icon(
            onPressed: () {
              // Trigger file picker
            },
            icon: const Icon(Icons.sync, size: 18),
            label: const Text('Ganti File'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
            ),
          ),
        ],

        // ✅ Tampilkan new file yang baru diupload
        if (hasNewFile) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                // File icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12B76A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.insert_drive_file,
                    color: Color(0xFF12B76A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentFile.path.split('/').last,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatFileSize(currentFile.lengthSync()),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Delete button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemoveNew,
                  color: Colors.red[400],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // ✅ Upload button (hanya tampil jika belum ada file)
        if (!hasExistingFile && !hasNewFile)
          FileUploadForm(
            label: '',
            descriptions: [
              if (formDataKey == 'dokumen_proyeksi')
                'Silakan unduh contoh dokumen di sini: Dokumen Proyeksi Proyek',
              'Maksimum size file 10 MB.',
            ],
            maxFileSizeMB: 10,
            onFilePicked: onFilePicked,
          ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;