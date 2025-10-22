import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/card/top-up-card.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-topUp-saldo-simpanan-wajib.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/tabel/tabel-transaksi.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/wallet_provider.dart';
import 'package:koperasi_rsb/models/topup_model.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final TabController _tabController;
  late double _deviceWidth;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch topup history dan wallet saldo saat page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = _getTokenFromContext();
      final userId = _getUserIdFromContext();

      if (token != null && token.isNotEmpty) {
        // Fetch topup history
        context.read<TopupProvider>().fetchTopupHistory(token);
        // Fetch wallet saldo
        if (userId != null && userId.isNotEmpty) {
          context.read<WalletProvider>().fetchWalletSaldo(token, userId);
        } else {}
      } else {
        context.read<TopupProvider>().setError('Token tidak tersedia');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Helper untuk ambil token dari AuthProvider
  String? _getTokenFromContext() {
    try {
      final authProvider = context.read<AuthProvider>();
      return authProvider.token;
    } catch (e) {
      return null;
    }
  }

  // Helper untuk ambil user ID dari AuthProvider
  String? _getUserIdFromContext() {
    try {
      final authProvider = context.read<AuthProvider>();
      return authProvider.userId;
    } catch (e) {
      return null;
    }
  }

  // Filter data berdasarkan status
  List<Map<String, String>> _filterDataByStatus(
    List<TopupModel> topups,
    String status,
  ) {
    List<TopupModel> filtered = [];

    if (status == "Menunggu Konfirmasi") {
      filtered = topups.where((t) => t.isPending).toList();
    } else if (status == "Berhasil") {
      filtered = topups.where((t) => t.isSuccess).toList();
    } else if (status == "Gagal") {
      filtered = topups
          .where((t) =>
              t.status.toLowerCase() == 'failed' ||
              t.status.toLowerCase() == 'gagal')
          .toList();
    }

    final result = filtered
        .map((topup) => {
              "tanggal": topup.displayDate,
              "metode": topup.namaBank ?? "N/A",
              "jenis": topup.displayTransactionType,
              "nominal": topup.displayAmount,
            })
        .toList();
    return result;
  }

  List<Map<String, String>> _searchFilter(
    List<Map<String, String>> data,
    String query,
  ) {
    if (query.isEmpty) return data;

    return data
        .where((item) =>
            item['tanggal']!.contains(query) ||
            item['metode']!.contains(query) ||
            item['jenis']!.contains(query) ||
            item['nominal']!.contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userRole = authProvider.userRole ?? 'BASIC';
    final isPlatinum = userRole == 'PLATINUM';
    final homeRoute = isPlatinum ? '/member-platinum' : '/member-reguler';

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, homeRoute);
        return false;
      },
      child: Scaffold(
        backgroundColor: lightGreen,
        bottomNavigationBar: AppBottomNav(
          currentIndex: 2,
          onItemSelected: (i) {
            if (i == 2) return;
            if (!mounted) return;
            switch (i) {
              case 0:
                Navigator.pushReplacementNamed(context, homeRoute);
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/my-project');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ======== BAGIAN ATAS (Saldo) ========
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 2),
                                child: Text(
                                  "Dompet",
                                  style: GoogleFonts.poppins(
                                    fontSize: _deviceWidth * 0.07,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Consumer WalletProvider untuk data dinamis
                              Consumer<WalletProvider>(
                                builder: (context, walletProvider, child) {
                                  return SizedBox(
                                    height: 227,
                                    child: PageView(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        setState(() => _currentPage = index);
                                      },
                                      children: [
                                        // Card 1: Saldo Top Up
                                        TopUpCard(
                                          title: "Saldo Top Up",
                                          amount: walletProvider.isLoading
                                              ? "Loading..."
                                              : walletProvider
                                                  .formattedSaldoTopup,
                                          onPressed: isPlatinum
                                              ? () {
                                                  showDialogPilihNominalPembayaran(
                                                      context,
                                                      isTopUpOnly: true);
                                                }
                                              : null,
                                        ),

                                        // Card 2: Simpanan Wajib
                                        TopUpCard(
                                          title: "Simpanan Wajib",
                                          amount: walletProvider.isLoading
                                              ? "Loading..."
                                              : walletProvider
                                                  .formattedSimpananWajib,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/payment-form',
                                              arguments: {
                                                'nominalPenyertaan': 120000,
                                                'totalPembayaran': 120000,
                                                'formattedNominal':
                                                    'Rp 120.000',
                                                'isTopUpOnly': false,
                                                'isSimpananWajib':
                                                    true, // ✅ FLAG BARU
                                              },
                                            );
                                          },
                                        ),

                                        // Card 3: Simpanan Pokok
                                        TopUpCard(
                                          title: "Simpanan Pokok",
                                          amount: walletProvider.isLoading
                                              ? "Loading..."
                                              : walletProvider
                                                  .formattedSimpananPokok,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 12),

                              // Page indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: _currentPage == index ? 10 : 8,
                                    height: _currentPage == index ? 10 : 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? darkGreen
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        // ======== BAGIAN BAWAH (Riwayat Transaksi) ========
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            margin: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Riwayat Transaksi",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: darkGreen,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Search..",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: darkGreen,
                                            ),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 6),
                                              child: Icon(
                                                Icons.search,
                                                size: 18,
                                                color: darkGreen,
                                              ),
                                            ),
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minWidth: 0,
                                              minHeight: 0,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                            filled: true,
                                            fillColor: lightGreen,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: darkGreen, width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: darkGreen, width: 1.8),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: darkGreen, width: 1.5),
                                            ),
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  TabBar(
                                    controller: _tabController,
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
                                    child: Consumer<TopupProvider>(
                                      builder: (context, provider, child) {
                                        if (provider.isLoading) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: darkGreen,
                                            ),
                                          );
                                        }

                                        if (provider.errorMessage != null) {
                                          return Center(
                                            child: Text(
                                              provider.errorMessage ??
                                                  'Terjadi kesalahan',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        }

                                        // Filter data by tab
                                        final menungguData =
                                            _filterDataByStatus(
                                          provider.topups,
                                          "Menunggu Konfirmasi",
                                        );
                                        final berhasilData =
                                            _filterDataByStatus(
                                          provider.topups,
                                          "Berhasil",
                                        );
                                        final gagalData = _filterDataByStatus(
                                          provider.topups,
                                          "Gagal",
                                        );

                                        // Apply search filter
                                        final searchQuery =
                                            _searchController.text;

                                        return TabBarView(
                                          controller: _tabController,
                                          children: [
                                            TransactionTable(
                                              status: "Menunggu Konfirmasi",
                                              data: _searchFilter(
                                                menungguData,
                                                searchQuery,
                                              ),
                                            ),
                                            TransactionTable(
                                              status: "Berhasil",
                                              data: _searchFilter(
                                                berhasilData,
                                                searchQuery,
                                              ),
                                            ),
                                            TransactionTable(
                                              status: "Gagal",
                                              data: _searchFilter(
                                                gagalData,
                                                searchQuery,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
