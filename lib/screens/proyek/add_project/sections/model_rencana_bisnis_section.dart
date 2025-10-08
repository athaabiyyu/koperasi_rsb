import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';

class ModelRencanaBisnisSection extends StatefulWidget {
  const ModelRencanaBisnisSection({super.key});

  @override
  State<ModelRencanaBisnisSection> createState() =>
      _ModelRencanaBisnisSectionState();
}

class _ModelRencanaBisnisSectionState extends State<ModelRencanaBisnisSection> {
  // Simple mock lists; replace with real data/service as needed
  final List<String> _provinsiList = const [
    'Jawa Timur',
    'Jawa Tengah',
    'Jawa Barat',
  ];
  final Map<String, List<String>> _kotaByProvinsi = const {
    'Jawa Timur': ['Surabaya', 'Sidoarjo', 'Malang'],
    'Jawa Tengah': ['Semarang', 'Solo', 'Magelang'],
    'Jawa Barat': ['Bandung', 'Bekasi', 'Depok'],
  };
  final Map<String, List<String>> _kecamatanByKota = const {
    'Surabaya': ['Rungkut', 'Sukolilo', 'Wonokromo'],
    'Sidoarjo': ['Candi', 'Taman', 'Buduran'],
    'Malang': ['Lowokwaru', 'Klojen', 'Sukun'],
    'Semarang': ['Tembalang', 'Banyumanik', 'Candisari'],
    'Solo': ['Banjarsari', 'Jebres', 'Serengan'],
    'Magelang': ['Magelang Utara', 'Magelang Tengah', 'Magelang Selatan'],
    'Bandung': ['Coblong', 'Cicendo', 'Lengkong'],
    'Bekasi': ['Bekasi Timur', 'Bekasi Selatan', 'Bekasi Utara'],
    'Depok': ['Beji', 'Sukmajaya', 'Cimanggis'],
  };

  String? _selectedProvinsi;
  String? _selectedKota;
  // ignore: unused_field
  String? _selectedKecamatan;

  @override
  Widget build(BuildContext context) {
    final kotaItems = _selectedProvinsi == null
        ? <String>[]
        : (_kotaByProvinsi[_selectedProvinsi] ?? <String>[]);
    final kecamatanItems = _selectedKota == null
        ? <String>[]
        : (_kecamatanByKota[_selectedKota] ?? <String>[]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Provinsi
        CustomDropdownFormField(
          label: 'Provinsi',
          hint: 'Pilih Provinsi',
          items: _provinsiList,
          validator: _requiredValue,
          onChanged: (val) {
            setState(() {
              _selectedProvinsi = val;
              _selectedKota = null;
              _selectedKecamatan = null;
            });
          },
        ),
        const SizedBox(height: 18),

        // Kabupaten/Kota
        CustomDropdownFormField(
          label: 'Kabupaten/Kota',
          hint: 'Pilih Kabupaten/Kota',
          items: kotaItems,
          validator: _requiredValue,
          onChanged: (val) {
            setState(() {
              _selectedKota = val;
              _selectedKecamatan = null;
            });
          },
        ),
        const SizedBox(height: 18),

        // Kecamatan
        CustomDropdownFormField(
          label: 'Kecamatan',
          hint: 'Pilih Kecamatan',
          items: kecamatanItems,
          validator: _requiredValue,
          onChanged: (val) => setState(() => _selectedKecamatan = val),
        ),
        const SizedBox(height: 18),

        // Detail Lokasi
        const CustomTextFormField(
          label: 'Detail Lokasi Tempat Usaha',
          hint: 'Detail Lokasi (Nama Jalan, No. Rumah, Blok/Unit No., Patokan)',
          maxLines: 4,
          validator: _required,
        ),
        const SizedBox(height: 22),

        // Brosur Katalog Produk (Optional)
        const SizedBox(height: 6),
        const FileUploadForm(
          label: 'Brosur Katalog Produk (Opsional)',
          descriptions: ['Maksimum size file 10 MB.'],
          maxFileSizeMB: 10,
        ),
        const SizedBox(height: 22),

        // Pendapatan per bulan
        const CustomTextFormField(
          label: 'Pendapatan Per Bulan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
        ),
        const SizedBox(height: 18),

        // Pengeluaran per bulan
        const CustomTextFormField(
          label: 'Pengeluaran Per Bulan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
        ),
        const SizedBox(height: 22),

        // Dokumen Proyeksi Proyek (required)
        const SizedBox(height: 6),
        const FileUploadForm(
          label: 'Dokumen Proyeksi Proyek',
          descriptions: [
            'Silakan unduh contoh dokumen di sini: Dokumen Proyeksi Proyek',
            'Maksimum size file 10 MB.',
          ],
          maxFileSizeMB: 10,
          // isRequired: true,
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
String? _requiredValue(dynamic v) => (v == null) ? 'Wajib dipilih' : null;
