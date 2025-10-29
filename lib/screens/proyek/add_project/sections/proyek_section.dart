import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class ProyekSection extends StatefulWidget {
  const ProyekSection({super.key});

  @override
  State<ProyekSection> createState() => _ProyekSectionState();
}

class _ProyekSectionState extends State<ProyekSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories
            .where((c) => c.name.trim().isNotEmpty)
            .toList();
        
        final categoryNames = categories
            .map((c) => c.name)
            .toSet()
            .toList();
        
        final currentKategori = provider.formData['kategori'];
        final validValue = (currentKategori != null && 
                           currentKategori.toString().trim().isNotEmpty &&
                           categoryNames.contains(currentKategori))
            ? currentKategori
            : null;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Proyek
            CustomTextFormField(
              label: 'Judul Proyek',
              hint: 'Cth. Ayam goreng Ana',
              validator: _required,
              initialValue: provider.formData['judul'],
              onChanged: (value) => provider.updateFormData('judul', value),
            ),
            const SizedBox(height: 18),

            // Kategori Proyek
            provider.isCategoriesLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : categories.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gagal memuat kategori',
                            style: TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => provider.loadCategories(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      )
                    : CustomDropdownFormField(
                        label: 'Kategori Proyek',
                        hint: 'Pilih Kategori Proyek',
                        items: categoryNames,
                        validator: _requiredValue,
                        value: validValue,
                        onChanged: (value) {
                          if (value == null) return;
                          
                          final category = categories.firstWhere(
                            (c) => c.name == value,
                          );
                          
                          provider.updateMultipleFormData({
                            'kategori': value,
                            'id_kategori': category.id,
                          });
                        },
                      ),
            const SizedBox(height: 18),

            // Deskripsi
            CustomTextFormField(
              label: 'Deskripsi',
              hint: 'Tuliskan deskripsi proyek anda:',
              maxLines: 6,
              validator: _required,
              initialValue: provider.formData['deskripsi'],
              onChanged: (value) => provider.updateFormData('deskripsi', value),
            ),
            const SizedBox(height: 22),

            // ✅ DOKUMEN PENDUKUNG - MULTIPLE FILES (MAX 4)
            _buildMultipleFileUpload(provider),
          ],
        );
      },
    );
  }

  // ✅ Widget untuk upload multiple files
  Widget _buildMultipleFileUpload(ProjectProvider provider) {
    // Get uploaded files from provider
    final uploadedFiles = provider.dokumenFiles ?? [];
    final canAddMore = uploadedFiles.length < 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            const Text(
              'Dokumen Pendukung',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${uploadedFiles.length}/4)',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Deskripsi
        Text(
          'Contoh: foto produk, NPWP, foto toko, slide pitch deck, dsb.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        Text(
          'Maksimum 4 file, ukuran max 10 MB per file.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),

        // List uploaded files
        if (uploadedFiles.isNotEmpty) ...[
          ...uploadedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileName = file.path.split('/').last;
            final fileSize = _formatFileSize(file.lengthSync());

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                          fileName,
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
                          fileSize,
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
                    onPressed: () {
                      provider.removeDokumenFile(index);
                      print('🗑️ File removed at index: $index');
                    },
                    color: Colors.red[400],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        // Upload button
        if (canAddMore)
          FileUploadForm(
            label: '', // Label sudah ada di atas
            maxFileSizeMB: 10,
            descriptions: const [], // Descriptions sudah ada di atas
            onFilePicked: (file) {
              if (file != null) {
                if (uploadedFiles.length >= 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Maksimum 4 file'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                provider.addDokumenFile(file);
                print('📎 File added: ${file.path}');
                print('📦 Total files: ${provider.dokumenFiles?.length ?? 0}');
              }
            },
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Maksimum 4 file telah tercapai',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ✅ Helper untuk format ukuran file
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
String? _requiredValue(dynamic v) => (v == null) ? 'Wajib dipilih' : null;