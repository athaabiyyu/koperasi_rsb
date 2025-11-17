import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/navigation/pagination_table.dart';
import 'package:koperasi_rsb/widgets-global/tabel/tabel-transaksi.dart';


class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage>
    with SingleTickerProviderStateMixin {
  int activeTab = 0;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController noRekController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  TabController? _tabController;

  String? selectedBank;

  final List<String> bankList = ['BCA', 'BNI', 'BRI', 'Mandiri', 'BSI', 'CIMB'];

  /// PAGINATION
  int _itemsPerPage = 5;

  int _currentPageMenunggu = 1;
  int _currentPageBerhasil = 1;
  int _currentPageGagal = 1;

  /// DUMMY TRANSAKSI
  final List<Map<String, String>> dataMenunggu = [
    {"tanggal": "14 Nov 2025", "metode": "BRI", "jenis": "Penarikan", "nominal": "Rp 300.000"},
  ];

  final List<Map<String, String>> dataBerhasil = [
    {"tanggal": "12 Nov 2025", "metode": "BCA", "jenis": "Penarikan", "nominal": "Rp 150.000"},
    {"tanggal": "10 Nov 2025", "metode": "Mandiri", "jenis": "Penarikan", "nominal": "Rp 200.000"},
  ];

  final List<Map<String, String>> dataGagal = [
    {"tanggal": "08 Nov 2025", "metode": "BNI", "jenis": "Penarikan", "nominal": "Rp 100.000"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    namaController.dispose();
    noRekController.dispose();
    jumlahController.dispose();
    super.dispose();
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
            child: CustomButton(
              text: "Ajukan Penarikan",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (selectedBank == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Silakan pilih bank"), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pengajuan penarikan diproses"), backgroundColor: Colors.green),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRiwayat() {
    // Inisialisasi TabController jika belum ada
    _tabController ??= TabController(length: 3, vsync: this);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Riwayat Transaksi",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
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

    final visibleData = data.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TransactionTable(status: status, data: visibleData),
        const SizedBox(height: 8),

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