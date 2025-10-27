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
    // Load categories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        // ✅ Filter categories: hapus yang kosong atau duplikat
        final categories = provider.categories
            .where((c) => c.name.trim().isNotEmpty)  // Hapus yang kosong
            .toList();
        
        // ✅ Ambil nama unik saja (hapus duplikat)
        final categoryNames = categories
            .map((c) => c.name)
            .toSet()  // Set otomatis hapus duplikat
            .toList();
        
        // ✅ Debug: cek apakah ada masalah
        print('📋 Categories loaded: ${categories.length}');
        print('📋 Unique names: ${categoryNames.length}');
        if (categories.length != categoryNames.length) {
          print('⚠️ WARNING: Ada kategori duplikat!');
        }
        
        // ✅ Validasi value sebelum digunakan
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
                        value: validValue,  // ✅ Gunakan validated value
                        onChanged: (value) {
                          if (value == null) return;
                          
                          // ✅ Find category by name
                          final category = categories.firstWhere(
                            (c) => c.name == value,
                          );
                          
                          print('📝 Category selected:');
                          print('  Name: ${category.name}');
                          print('  ID: ${category.id}');
                          
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

            // Dokumen Pendukung
            FileUploadForm(
              label: 'Dokumen Pendukung (Foto Toko, NPWP, dsb)',
              maxFileSizeMB: 10,
              descriptions: const [
                'Contoh: foto produk, NPWP, foto toko, slide pitch deck, dsb.',
                'Maksimum size file 10 MB.',
              ],
              onFilePicked: (file) {
                if (file != null) {
                  provider.addDokumenFile(file);
                  print('📎 File added: ${file.path}');
                }
              },
            ),
          ],
        );
      },
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
String? _requiredValue(dynamic v) => (v == null) ? 'Wajib dipilih' : null;