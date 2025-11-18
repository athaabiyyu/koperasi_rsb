import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/navigation/pagination_table.dart';
import 'package:koperasi_rsb/widgets-global/tabel/tabel-penarikan-saldo.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-proses-verifikasi.dart';
import 'package:koperasi_rsb/services/topup_service.dart';
import 'package:koperasi_rsb/models/topup_model.dart';
import 'package:koperasi_rsb/models/withdraw_model.dart';
import 'package:koperasi_rsb/utils/format_helper.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage>
    with SingleTickerProviderStateMixin {
  int activeTab = 0;

  final _formKey = GlobalKey<FormState>();
  final TopupService _topupService = TopupService();
  final FormatHelper _formatHelper = FormatHelper();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController noRekController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  TabController? _tabController;

  String? selectedBank;

  final List<String> bankList = ['BCA', 'BNI', 'BRI', 'Mandiri', 'BSI', 'CIMB'];

  /// PAGINATION
  int _itemsPerPage = 10;

  int _currentPageMenunggu = 1;
  int _currentPageBerhasil = 1;
  int _currentPageGagal = 1;

  /// DATA DARI BACKEND
  List<Map<String, String>> dataMenunggu = [];
  List<Map<String, String>> dataBerhasil = [];
  List<Map<String, String>> dataGagal = [];

  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRiwayatTransaksi();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    namaController.dispose();
    noRekController.dispose();
    jumlahController.dispose();
    super.dispose();
  }

  // Load riwayat transaksi dari backend
  Future<void> _loadRiwayatTransaksi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _topupService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final result = await _topupService.getTopupByUserId(token);

      if (result['success'] == true) {
        final List<TopupModel> topupList = result['data'] as List<TopupModel>;

        setState(() {
          dataMenunggu = _formatHelper.filterByStatus(topupList, 'Menunggu');
          dataBerhasil = _formatHelper.filterByStatus(topupList, 'Berhasil');
          dataGagal = _formatHelper.filterByStatus(topupList, 'Gagal');
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal memuat riwayat'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat riwayat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Validasi form dulu, lalu tampilkan pop-up konfirmasi
  void _handleAjukanPenarikan() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih bank"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ Tampilkan pop-up konfirmasi sebelum submit
    _showConfirmationDialog();
  }

  // ✅ Pop-up konfirmasi persis seperti KonfirmasiPembayaran
  void _showConfirmationDialog() {
    final title = "Konfirmasi Penarikan Saldo";
    final description = 
        "Apakah Anda yakin ingin mengajukan penarikan saldo?\n\n"
        "Setelah Anda konfirmasi, pengajuan akan dikirim ke Admin untuk diverifikasi. "
        "Proses verifikasi memakan waktu hingga 2x24 jam.\n\n"
        "Dana akan ditransfer ke rekening Anda setelah admin menyetujui pengajuan ini.";

    showCustomDialog(
      context: context,
      title: title,
      description: description,
      imagePath: "assets/images/ava-proses-verifikasi.png",
      buttonText: "Ya, Ajukan Sekarang",
      onButtonPressed: () {
        Navigator.of(context).pop(); // Tutup dialog
        _submitWithdraw(); // Lanjutkan submit
      },
      bottomText: "Batal",
      onBottomTextTap: () {
        Navigator.of(context).pop(); // Tutup dialog tanpa submit
      },
    );
  }

  // ✅ Submit penarikan saldo (dipanggil setelah user konfirmasi di dialog)
  Future<void> _submitWithdraw() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Parsing nominal (hapus format Rupiah)
      final nominalStr = jumlahController.text
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim();
      final nominal = int.tryParse(nominalStr) ?? 0;

      if (nominal <= 0) {
        throw Exception('Nominal tidak valid');
      }

      final request = WithdrawRequest(
        namaBank: selectedBank!,
        noRekening: noRekController.text,
        namaPemilikRekening: namaController.text,
        nominal: nominal,
      );

      final response = await _topupService.withdrawSaldo(request);

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        if (response['success'] == true) {
          // ✅ Tampilkan dialog sukses setelah submit berhasil
          _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Pengajuan gagal'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengajukan penarikan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Dialog sukses setelah submit
  void _showSuccessDialog() {
    final title = "Penarikan Saldo Sedang Diproses";
    final description = 
        "Pengajuan penarikan saldo Anda sedang diverifikasi oleh Admin. "
        "Tunggu hingga 2x24 jam.\n\n"
        "Dana akan ditransfer ke rekening Anda setelah admin mengkonfirmasi penarikan.";

    showCustomDialog(
      context: context,
      title: title,
      description: description,
      imagePath: "assets/images/ava-proses-verifikasi.png",
      buttonText: "Saya Mengerti",
      onButtonPressed: () {
        Navigator.of(context).pop(); // Tutup dialog
        
        // Reset form
        _formKey.currentState!.reset();
        namaController.clear();
        noRekController.clear();
        jumlahController.clear();
        setState(() {
          selectedBank = null;
        });

        // Reload riwayat
        _loadRiwayatTransaksi();

        // Pindah ke tab riwayat
        setState(() {
          activeTab = 1;
        });
      },
      bottomText: "Butuh bantuan? Hubungi Admin",
      onBottomTextTap: () {
        print("User klik Hubungi Admin");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Penarikan Saldo",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 1),
            child: Center(
              child: Wrap(
                spacing: 30,
                children: [
                  _buildTabButton("Tarik Saldo", 0),
                  _buildTabButton("Riwayat transfer Penarikan", 1),
                ],
              ),
            ),
          ),

          /// Garis tab
          Container(height: 0.5, color: strokeGray),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: activeTab == 0 ? _buildForm() : _buildRiwayat(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final bool isActive = activeTab == index;

    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;

    return InkWell(
      onTap: () {
        setState(() {
          activeTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: isActive ? darkGreen : Colors.black87,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? textWidth : 0,
            color: isActive ? darkGreen : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tarik Saldo",
            style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          CustomTextFormField(
            label: "Nama Pemilik Rekening",
            hint: "Nama Pemilik Rekening",
            controller: namaController,
            validator: (v) => v == null || v.isEmpty ? "Nama wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            label: "No. Rekening",
            hint: "No. Rekening",
            controller: noRekController,
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? "Nomor rekening wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          Text(
            "Pilih Bank *",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: strokeGray),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBank,
                hint: Text("Pilih Bank", style: GoogleFonts.poppins(color: strokeGray)),
                isExpanded: true,
                items: bankList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedBank = v;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          CustomTextFormField(
            label: "Jumlah Penarikan",
            hint: "Masukkan nominal",
            controller: jumlahController,
            keyboardType: TextInputType.number,
            formatRupiah: true,
            validator: (v) => v == null || v.isEmpty ? "Jumlah wajib diisi" : null,
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Ajukan Penarikan",
                    onPressed: _handleAjukanPenarikan, // ✅ Panggil pop-up dulu
                  ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRiwayat() {
    _tabController ??= TabController(length: 3, vsync: this);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Riwayat Transaksi",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: darkGreen),
              onPressed: _loadRiwayatTransaksi,
              tooltip: 'Refresh',
            ),
          ],
        ),
        const SizedBox(height: 16),

        TabBar(
          controller: _tabController!,
          labelColor: darkGreen,
          unselectedLabelColor: darkGreen,
          indicatorColor: darkGreen,
          labelStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "Menunggu Konfirmasi"),
            Tab(text: "Berhasil"),
            Tab(text: "Gagal"),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController!,
            children: [
              SingleChildScrollView(
                child: _buildPaginatedTable(
                  "Menunggu Konfirmasi",
                  dataMenunggu,
                ),
              ),
              SingleChildScrollView(
                child: _buildPaginatedTable(
                  "Berhasil",
                  dataBerhasil,
                ),
              ),
              SingleChildScrollView(
                child: _buildPaginatedTable(
                  "Gagal",
                  dataGagal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginatedTable(String status, List<Map<String, String>> data) {
    int currentPage;

    if (status == "Menunggu Konfirmasi") {
      currentPage = _currentPageMenunggu;
    } else if (status == "Berhasil") {
      currentPage = _currentPageBerhasil;
    } else {
      currentPage = _currentPageGagal;
    }

    int totalPages = (data.length / _itemsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    final startIndex = (currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage) > data.length
        ? data.length
        : (startIndex + _itemsPerPage);

    final List<Map<String, String>> visibleData = data.isNotEmpty 
        ? data.sublist(startIndex, endIndex).cast<Map<String, String>>()
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        data.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Tidak ada data',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
              )
            : PenarikanSaldoTable(status: status, data: visibleData),
        const SizedBox(height: 8),

        if (data.isNotEmpty)
          PaginationWidget(
            currentPage: currentPage,
            totalPages: totalPages,
            onPrevious: currentPage > 1
                ? () {
                    setState(() {
                      if (status == "Menunggu Konfirmasi") {
                        _currentPageMenunggu--;
                      } else if (status == "Berhasil") {
                        _currentPageBerhasil--;
                      } else {
                        _currentPageGagal--;
                      }
                    });
                  }
                : null,
            onNext: currentPage < totalPages
                ? () {
                    setState(() {
                      if (status == "Menunggu Konfirmasi") {
                        _currentPageMenunggu++;
                      } else if (status == "Berhasil") {
                        _currentPageBerhasil++;
                      } else {
                        _currentPageGagal++;
                      }
                    });
                  }
                : null,
          ),
      ],
    );
  }
}