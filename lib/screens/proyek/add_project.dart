import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/proyek_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pendanaan_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/model_rencana_bisnis_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pembagian_hasil_section.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
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
      // Submit final
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form terkirim (dummy).')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.isEditingDraft ? 'Lanjutkan Draft' : 'Buat Proyek',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: PageView(
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
              ),
            ],
          ),
          _sectionWrapper(
            index: 2,
            title: 'Model & Rencana Bisnis',
            subtitle: 'Detail model bisnis dan rencana operasional',
            children: const [ModelRencanaBisnisSection()],
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: _deviceWidth * 0.04,
          right: _deviceWidth * 0.04,
          top: _deviceHeight * 0.005,
          bottom: _deviceHeight * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
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
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: darkGreen,
                  ),
                ),
              ),
            ),
            SizedBox(width: _deviceWidth * 0.04),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  padding: EdgeInsets.symmetric(
                    vertical: _deviceHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _selanjutnya,
                child: Text(
                  _step < 3 ? 'Selanjutnya' : 'Buat Proyek',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
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
    return Form(
      key: _formKeys[index],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.roboto(fontSize: 13, color: grayFont),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300, height: 1),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
