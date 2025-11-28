import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/project_information_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/status_project_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/investors_section.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/funding_history_section.dart';
import 'package:koperasi_rsb/widgets-global/dialog/buy_token_dialog.dart';
import 'package:koperasi_rsb/widgets-global/dialog/confirm_purchase_dialog.dart';
// import 'package:koperasi_rsb/services/token_service.dart';
import 'package:koperasi_rsb/services/prospectus_service.dart';
import 'package:koperasi_rsb/providers/wallet_provider.dart';
import 'package:koperasi_rsb/providers/token_provider.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectId;
  final String? imageUrl;
  final String? status;
  final String? title;
  final String? owner;
  final int? collectedToken;
  final int? remainingDays;
  final int? maxToken;
  final String? projectOwnerId;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.imageUrl,
    this.status,
    this.title,
    this.owner,
    this.collectedToken,
    this.remainingDays,
    this.maxToken,
    this.projectOwnerId,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  ProjectListItem? _projectDetail;
  bool _isLoading = true;
  String? _error;
  // final TokenService _tokenService = TokenService(); // no longer used; provider handles purchase
  final ProspectusService _prospectusService = ProspectusService();
  bool _isDownloadingProspectus = false;
  String? _handledBuySuccessMsg;
  String? _handledBuyErrorMsg;

  @override
  void initState() {
    super.initState();
    _loadProjectDetail();
    _loadWalletBalance();
  }

  @override
  void dispose() {
    // Ensure local banner state is cleared when leaving this page
    try {
      final tp = Provider.of<TokenProvider>(context, listen: false);
      tp.clearBuyTokenMessages();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _loadWalletBalance() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );

      final token = authProvider.token;
      final userId = authProvider.userId;

      if (token != null && userId != null) {
        await walletProvider.fetchWalletSaldo(token, userId);
      }
    } catch (e) {
      print('Error loading wallet balance: $e');
    }
  }

  Future<void> _loadProjectDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      final detail = await projectProvider.getProjectDetail(widget.projectId);

      if (mounted) {
        setState(() {
          _projectDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBuyToken() async {
    if (_projectDetail == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi Anda telah berakhir. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi status project
    if (_projectDetail!.status != 'PENDANAAN DIBUKA') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pendanaan untuk proyek ini belum dibuka atau sudah ditutup',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validasi minimal dan maksimal pembelian
    final minBeli = _projectDetail!.minimalPembelian ?? 0;
    final maxBeli = _projectDetail!.maksimalPembelian ?? 0;
    final pricePerToken = _projectDetail!.hargaPerUnit ?? 0;

    if (minBeli <= 0 || maxBeli <= 0 || pricePerToken <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informasi pembelian token tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hitung token tersisa
    // Jika backend belum kirim data tokenTerjual, fetch dari API
    final totalToken = _projectDetail!.jumlahKoin ?? 0;
    int remainingTokens = totalToken;

    // Coba ambil data token tersisa dari API
    // try {
    //   final tokenInfo = await _tokenService.getAvailableTokens(
    //     token: token,
    //     projectId: widget.projectId,
    //   );

    //   if (tokenInfo['success'] == true) {
    //     remainingTokens = tokenInfo['availableTokens'] ?? totalToken;
    //   }
    // } catch (e) {
    //   // Jika gagal, gunakan total token sebagai fallback
    //   print('Error fetching available tokens: $e');
    // }

    if (remainingTokens <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token sudah habis terjual'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // DIALOG 1: Pilih jumlah token
    final selectedTokens = await showBuyTokenDialog(
      context,
      remaining: remainingTokens,
      pricePerToken: pricePerToken,
      maxPurchase: maxBeli,
    );

    // User cancel atau tidak memilih
    if (selectedTokens == null || selectedTokens <= 0) return;

    // Validasi jumlah token sebelum lanjut ke konfirmasi
    if (selectedTokens < minBeli) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimal pembelian adalah $minBeli token'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTokens > maxBeli) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal pembelian adalah $maxBeli token'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTokens > remainingTokens) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token tersisa hanya $remainingTokens'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get wallet balance dari WalletProvider (tidak pakai Consumer di sini karena di dalam method)
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final walletBalance = walletProvider.saldoTopup.toInt();

    // Validasi saldo mencukupi
    final totalPrice = selectedTokens * pricePerToken;
    if (walletBalance < totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saldo tidak mencukupi. Saldo Anda: ${walletProvider.formattedSaldoTopup}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // DIALOG 2: Konfirmasi pembelian
    final confirmed = await showConfirmPurchaseDialog(
      context,
      projectTitle: _projectDetail!.judul,
      tokens: selectedTokens,
      pricePerToken: pricePerToken,
      walletBalance: walletBalance,
      paymentMethodName: 'Saldo Dompet',
    );

    // User tidak confirm
    if (confirmed != true) return;

    // Proses pembelian
    await _processBuyToken(token, selectedTokens);
  }

  Future<void> _processBuyToken(String token, int jumlahToken) async {
    // Fire via TokenProvider; UI will reflect status via banner (like create project)
    final tp = Provider.of<TokenProvider>(context, listen: false);
    Future<void>(() async {
      await tp.buyToken(
        token: token,
        projectId: widget.projectId,
        projectName: _projectDetail!.judul,
        jumlahToken: jumlahToken,
      );
    });
  }

  Future<void> _handleDownloadProspectus() async {
    if (_isDownloadingProspectus) return; // Prevent double tap

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi Anda telah berakhir. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isDownloadingProspectus = true;
    });

    // Show loading snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Mengunduh prospektus...'),
          ],
        ),
        duration: Duration(seconds: 30),
        backgroundColor: Colors.blue,
      ),
    );

    try {
      final result = await _prospectusService.downloadAndOpenProspectus(
        token: token,
        projectId: widget.projectId,
      );

      // Close loading snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (mounted) {
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      result['message'] ?? 'Prospektus berhasil dibuka',
                    ),
                  ),
                ],
              ),
              backgroundColor: darkGreen,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      result['message'] ?? 'Gagal membuka prospektus',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingProspectus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_error != null || _projectDetail == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error ?? 'Gagal memuat detail proyek',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProjectDetail,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final project = _projectDetail!;

    // Get user info from AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.userId;
    final userRole = authProvider.userRole;

    // Check if current user is the project owner
    final isProjectOwner = project.user.id == currentUserId;

    // Check if user is PLATINUM
    final isPlatinum = userRole == 'PLATINUM';

    // Determine which tabs to show
    List<Tab> tabs = [];
    List<Widget> tabViews = [];

    // Tab 1: Informasi Proyek (Always visible)
    tabs.add(const Tab(text: 'Informasi Proyek'));
    tabViews.add(ProjectInformationTab(project: project));

    // Tab 2: Status Pengajuan
    // Show if: BASIC user OR (PLATINUM user AND is project owner)
    if (userRole == 'BASIC' || (userRole == 'PLATINUM' && isProjectOwner)) {
      tabs.add(const Tab(text: 'Status Pengajuan'));
      tabViews.add(SubmissionStatusTab(project: project));
    }

    // Tab 3: Penanam Modal (Always visible)
    tabs.add(const Tab(text: 'Penanam Modal'));
    tabViews.add(InvestorsTab(project: project));

    // Tab 4: Riwayat Pendanaan Dari Koperasi
    // Show if: BASIC user OR (PLATINUM user AND is project owner)
    if (userRole == 'BASIC' || (userRole == 'PLATINUM' && isProjectOwner)) {
      tabs.add(const Tab(text: 'Riwayat Pendanaan Dari Koperasi'));
      tabViews.add(FundingHistoryTab(project: project));
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: Text(
            "Detail Proyek",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
            indicatorColor: darkGreen,
            labelColor: darkGreen,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: Builder(
          builder: (context) {
            final tokenProvider = Provider.of<TokenProvider>(context);

            // React once per new success/error message to avoid loops
            if (tokenProvider.buyTokenSuccess != null &&
                tokenProvider.buyTokenSuccess != _handledBuySuccessMsg) {
              _handledBuySuccessMsg = tokenProvider.buyTokenSuccess;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                _loadProjectDetail();
                try {
                  final auth = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  final wallet = Provider.of<WalletProvider>(
                    context,
                    listen: false,
                  );
                  await wallet.fetchWalletSaldo(
                    auth.token ?? '',
                    auth.userId ?? '',
                  );
                } catch (_) {}
                await Future.delayed(const Duration(seconds: 3));
                if (mounted) {
                  Provider.of<TokenProvider>(
                    context,
                    listen: false,
                  ).clearBuyTokenMessages();
                  _handledBuySuccessMsg = null;
                }
              });
            } else if (tokenProvider.buyTokenError != null &&
                tokenProvider.buyTokenError != _handledBuyErrorMsg) {
              _handledBuyErrorMsg = tokenProvider.buyTokenError;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Future.delayed(const Duration(seconds: 3));
                if (mounted) {
                  Provider.of<TokenProvider>(
                    context,
                    listen: false,
                  ).clearBuyTokenMessages();
                  _handledBuyErrorMsg = null;
                }
              });
            }

            Widget? banner;
            if (tokenProvider.isBuyingToken) {
              banner = _buildProcessBanner(
                color: Colors.orange,
                bgBorderColor: Colors.orangeAccent.withOpacity(0.25),
                title: 'Pembelian token sedang diproses',
                message:
                    'Anda dapat melanjutkan aktivitas. Kami akan memberi tahu ketika selesai.',
                icon: Icons.info_rounded,
              );
            } else if (tokenProvider.buyTokenSuccess != null) {
              banner = _buildProcessBanner(
                color: darkGreen,
                bgBorderColor: darkGreen.withOpacity(0.2),
                title: 'Pembelian token berhasil',
                message: tokenProvider.buyTokenSuccess!,
                icon: Icons.check_circle,
              );
            } else if (tokenProvider.buyTokenError != null) {
              banner = _buildProcessBanner(
                color: Colors.red,
                bgBorderColor: Colors.red.withOpacity(0.2),
                title: 'Pembelian token gagal',
                message: tokenProvider.buyTokenError!,
                icon: Icons.error_outline,
              );
            }

            return Column(
              children: [
                if (banner != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: banner,
                  ),
                Expanded(child: TabBarView(children: tabViews)),
              ],
            );
          },
        ),
        // Bottom action buttons - only show for PLATINUM users
        bottomNavigationBar: isPlatinum
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _handleBuyToken,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.shopping_cart, size: 20),
                          label: Text(
                            'Beli Token',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _isDownloadingProspectus
                              ? null
                              : _handleDownloadProspectus,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkGreen,
                            side: BorderSide(
                              color: _isDownloadingProspectus
                                  ? Colors.grey
                                  : darkGreen,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _isDownloadingProspectus
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: Text(
                            'Prospektus',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildProcessBanner({
    required Color color,
    required Color bgBorderColor,
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bgBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
