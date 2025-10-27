import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/proyek_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pendanaan_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/model_rencana_bisnis_section.dart';
import 'package:koperasi_rsb/screens/proyek/add_project/sections/pembagian_hasil_section.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

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
  final PageController _pageController = PageController();
  int _step = 0;

  final List<GlobalKey<FormState>> _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  @override
  void initState() {
    super.initState();
    // Load categories when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditingDraft && widget.draftData != null) {
        context.read<ProjectProvider>().updateMultipleFormData(widget.draftData!);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _simpanDraft() {
    final provider = context.read<ProjectProvider>();
    provider.saveDraft().then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _selanjutnya() async {
    final currentKey = _formKeys[_step];
    if (currentKey.currentState?.validate() != true) return;

    // Validate percentages on last step
    if (_step == 3) {
      final provider = context.read<ProjectProvider>();
      if (!provider.validatePercentages()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Total persentase harus 100%. Saat ini: ${provider.getPercentageTotal()}%'
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final success = await provider.createProject();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proyek berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/my-project');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Gagal membuat proyek'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      return;
    }

    // Move to next step
    setState(() => _step++);
    _pageController.animateToPage(
      _step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: darkGreen, size: 40),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
              _pageController.animateToPage(
                _step,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Buat Proyek',
          style: GoogleFonts.poppins(
            fontSize: deviceWidth * 0.05,
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
              children: const [ProyekSection()],
            ),
            _sectionWrapper(
              index: 1,
              title: 'Pendanaan',
              subtitle: 'Berisi informasi pengajuan pendanaan anda',
              children: const [PendanaanSection()],
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
              subtitle: 'Berisi informasi mengenai pembagian hasil antar pengelola dan investor',
              children: const [PembagianHasilSection()],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.only(
              left: deviceWidth * 0.06,
              right: deviceWidth * 0.06,
              top: deviceHeight * 0.03,
              bottom: deviceHeight * 0.03,
            ),
            decoration: const BoxDecoration(color: lightGreen),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.015),
                      side: const BorderSide(color: darkGreen, width: 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: provider.status == ProjectStatus.loading 
                        ? () {} 
                        : _simpanDraft,
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
                SizedBox(width: deviceWidth * 0.04),
                Expanded(
                  child: CustomButton(
                    text: _step < 3 ? 'Selanjutnya' : 'Buat Proyek',
                    color: darkGreen,
                    textColor: Colors.white,
                    radius: 10,
                    onPressed: provider.status == ProjectStatus.loading 
                        ? () {} 
                        : _selanjutnya,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionWrapper({
    required int index,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKeys[index],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: deviceWidth * 0.075,
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