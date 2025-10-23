import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'dart:io';

import 'package:koperasi_rsb/screens/proyek/add_project/sections/proyek_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pendanaan_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/model_rencana_bisnis_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pembagian_hasil_section.dart';
import 'package:koperasi_rsb/models/project_model.dart';
import 'package:koperasi_rsb/services/project_service.dart';

class AddProjectPage extends StatefulWidget {
  final bool isEditingDraft;
  final Map<String, dynamic>? draftData;

  const AddProjectPage({
    super.key,
    this.isEditingDraft = false,
    this.draftData,
  });

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  // Multi-step state
  final PageController _pageController = PageController();
  int _step =
      0; // 0: Proyek, 1: Pendanaan, 2: Model & Rencana Bisnis, 3: Pembagian Hasil

  // Per-section forms
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );

  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  // lifted state for kategori
  String? _kategori;

  // Pendanaan controllers
  final TextEditingController _nominalCtrl = TextEditingController();
  final TextEditingController _asetJaminanCtrl = TextEditingController();
  final TextEditingController _nilaiAsetCtrl = TextEditingController();

  // Model & Rencana Bisnis controllers
  String? _provinsi;
  String? _kota;
  String? _kecamatan;
  final TextEditingController _detailLokasiCtrl = TextEditingController();
  final TextEditingController _pendapatanCtrl = TextEditingController();
  final TextEditingController _pengeluaranCtrl = TextEditingController();

  // Files
  File? _dokumenPendukungFile;
  File? _brosurProdukFile;
  File? _dokumenProyeksiFile;

  @override
  void dispose() {
    _pageController.dispose();
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    _nominalCtrl.dispose();
    _asetJaminanCtrl.dispose();
    _nilaiAsetCtrl.dispose();
    _detailLokasiCtrl.dispose();
    _pendapatanCtrl.dispose();
    _pengeluaranCtrl.dispose();
    super.dispose();
  }

  void _simpanDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft disimpan (sementara).')),
    );
  }

  void _selanjutnya() {
    final currentKey = _formKeys[_step];
    if (currentKey.currentState?.validate() != true) return;

    if (_step < 3) {
      setState(() => _step++);
      _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitProject();
    }
  }

  Future<void> _submitProject() async {
    // Validate all forms across steps
    for (final key in _formKeys) {
      if (key.currentState?.validate() != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Periksa kembali form, beberapa field wajib belum terisi.')),
        );
        return;
      }
    }

    final project = ProjectModel(
      nama: _judulCtrl.text.trim(),
      kategori: _kategori ?? '',
      deskripsiProyek: _deskripsiCtrl.text.trim(),
      nominal: double.tryParse(_nominalCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      namaJaminan: _asetJaminanCtrl.text.trim(),
      nilaiJaminan: double.tryParse(_nilaiAsetCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      provinsi: _provinsi ?? '',
      kota: _kota ?? '',
      kecamatan: _kecamatan ?? '',
      deskripsiLokasi: _detailLokasiCtrl.text.trim(),
      pendapatanBulanan: double.tryParse(_pendapatanCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      pengeluaranBulanan: double.tryParse(_pengeluaranCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
    );

    final res = await ProjectService.createProject(project, _dokumenPendukungFile, _brosurProdukFile, _dokumenProyeksiFile);

    if (!mounted) return;

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Berhasil')));
      Navigator.pushReplacementNamed(context, '/my-project');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal mengirim proyek')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: darkGreen, size: 40),
          onPressed: () {
            if (_step > 0) {
              // Jika bukan halaman pertama, mundur 1 step di PageView
              setState(() => _step--);
              _pageController.animateToPage(
                _step,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              // Jika halaman pertama, keluar dari AddProjectPage
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Buat Proyek',
          style: GoogleFonts.poppins(
            fontSize: _deviceWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _sectionWrapper(
              index: 0,
              title: 'Proyek',
              subtitle: 'Berisi informasi proyek anda',
              children: [
                ProyekSection(
                  initialJudul: widget.draftData != null
                      ? widget.draftData!['title'] as String?
                      : null,
                  judulController: _judulCtrl,
                  deskripsiController: _deskripsiCtrl,
                  initialKategori: widget.draftData != null ? widget.draftData!['kategori'] as String? : null,
                  onKategoriChanged: (v) => setState(() => _kategori = v),
                  onDokumenPendukungPicked: (f) => _dokumenPendukungFile = f,
                ),
              ],
            ),
            _sectionWrapper(
              index: 1,
              title: 'Pendanaan',
              subtitle: 'Berisi informasi pengajuan pendanaan anda',
              children: [
                PendanaanSection(
                  initialNominal: widget.draftData != null
                      ? widget.draftData!['tokenDitawarkan'] as int?
                      : null,
                  nominalController: _nominalCtrl,
                  asetJaminanController: _asetJaminanCtrl,
                  nilaiAsetController: _nilaiAsetCtrl,
                ),
              ],
            ),
            _sectionWrapper(
              index: 2,
              title: 'Model & Rencana Bisnis',
              subtitle: 'Detail model bisnis dan rencana operasional',
              children: [
                ModelRencanaBisnisSection(
                  onProvinsiChanged: (v) => _provinsi = v,
                  onKotaChanged: (v) => _kota = v,
                  onKecamatanChanged: (v) => _kecamatan = v,
                  detailLokasiCtrl: _detailLokasiCtrl,
                  pendapatanCtrl: _pendapatanCtrl,
                  pengeluaranCtrl: _pengeluaranCtrl,
                  onBrosurPicked: (f) => _brosurProdukFile = f,
                  onProyeksiPicked: (f) => _dokumenProyeksiFile = f,
                ),
              ],
            ),
            _sectionWrapper(
              index: 3,
              title: 'Pembagian Hasil',
              subtitle:
                  'Berisi informasi mengenai pembagian hasil antar pengelola dan investor',
              children: const [PembagianHasilSection()],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: _deviceWidth * 0.06,
          right: _deviceWidth * 0.06,
          top: _deviceHeight * 0.03,
          bottom: _deviceHeight * 0.03,
        ),
        decoration: const BoxDecoration(
          color: lightGreen,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: _deviceHeight * 0.015,
                  ),
                  side: const BorderSide(color: darkGreen, width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _simpanDraft,
                child: Text(
                  'Draft',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: darkGreen,
                  ),
                ),
              ),
            ),
            SizedBox(width: _deviceWidth * 0.04),
            Expanded(
              child: CustomButton(
                text: _step < 3 ? 'Selanjutnya' : 'Buat Proyek',
                color: darkGreen,
                textColor: Colors.white,
                radius: 10,
                onPressed: _selanjutnya,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Sections ----------
  Widget _sectionWrapper({
    required int index,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKeys[index],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 120,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: _deviceWidth * 0.075,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: grayFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    const SizedBox(height: 30),
                    ...children,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
