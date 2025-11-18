import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/project_detail.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:koperasi_rsb/providers/token_provider.dart';
import 'package:koperasi_rsb/screens/member-platinum/dashboard/section/platinum_header.dart';
import 'package:koperasi_rsb/widgets-global/card/transaction_history_section.dart';

class PremiumDashboardPage extends StatefulWidget {
  const PremiumDashboardPage({Key? key}) : super(key: key);

  @override
  State<PremiumDashboardPage> createState() => _PremiumDashboardPageState();
}

class _PremiumDashboardPageState extends State<PremiumDashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = _getTokenFromContext();
      if (token != null && token.isNotEmpty) {
        // Load topup history
        context.read<TopupProvider>().fetchTopupHistory(token);
        
        // Load token usage details
        context.read<TokenProvider>().loadTokenUsageDetails(token);
      }
    });
  }

  String? _getTokenFromContext() {
    try {
      final authProvider = context.read<AuthProvider>();
      return authProvider.token;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'User';
    final userRole = authProvider.userRole ?? 'BASIC';
    final isplatinum = userRole == 'PLATINUM';

    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (i) {
          if (!mounted) return;
          switch (i) {
            case 0:
              if (ModalRoute.of(context)?.settings.name != '/member-premium') {
                Navigator.pushReplacementNamed(context, '/member-premium');
              }
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/project-list');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/wallet');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PremiumHeader(userName: userName, isplatinum: isplatinum),
              SizedBox(height: _deviceHeight * 0.03),
              _buildTokenUsageSection(),
              SizedBox(height: _deviceHeight * 0.02),
              const TransactionHistorySection(
                variant: TransactionHistoryVariant.premium,
              ),
              SizedBox(height: _deviceHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenUsageSection() {
    return Consumer<TokenProvider>(
      builder: (context, tokenProvider, child) {
        // Show loading state
        if (tokenProvider.isLoadingUsage) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(),
                SizedBox(height: _deviceHeight * 0.008),
                SizedBox(
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }

        // Show error state
        if (tokenProvider.usageError != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(),
                SizedBox(height: _deviceHeight * 0.008),
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[300],
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          tokenProvider.usageError!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Get top 3 token usage
        final tokenUsageList = tokenProvider.getTopTokenUsage(limit: 3);

        // Show empty state - Tidak ada token sama sekali
        if (tokenUsageList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(),
                SizedBox(height: _deviceHeight * 0.008),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Anda Belum Memiliki Token',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[800],
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Mulai investasi dengan membeli token\nuntuk mengikuti proyek',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Show data
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              SizedBox(height: _deviceHeight * 0.008),
              Builder(
                builder: (context) {
                  final double listHeight = (_deviceHeight * 0.24)
                      .clamp(180, 230)
                      .toDouble();
                  return SizedBox(
                    height: listHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tokenUsageList.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: _deviceWidth * 0.035),
                      itemBuilder: (context, index) {
                        final item = tokenUsageList[index];
                        return _TokenUsageCard(
                          title: item.judul,
                          owner: item.user.nama,
                          status: item.statusLabel,
                          modal: item.tokenCountInt,
                          hasil: item.persentaseDouble.toInt(),
                          modalLabel: 'Jumlah Penggunaan Token',
                          hasilLabel: 'Return',
                          nominalReturn: item.formattedNominal,
                          cardHeight: listHeight,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProjectDetailPage(
                                  projectId: item.id,
                                  imageUrl: item.imageUrl,
                                  status: item.status,
                                  title: item.judul,
                                  owner: item.user.nama,
                                  collectedToken: item.tokenCountInt,
                                  remainingDays: item.isCompleted ? 0 : 12,
                                  maxToken: item.jumlahKoin ?? 0,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: AutoSizeText(
            'Detail Penggunaan Token',
            style: GoogleFonts.poppins(
              fontSize: _deviceWidth * 0.045,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: _deviceWidth * 0.02),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/member-premium/token-usage');
            },
            child: AutoSizeText(
              'Lihat lainnya',
              style: GoogleFonts.poppins(
                color: darkGreen,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _TokenUsageCard extends StatelessWidget {
  final String title;
  final String owner;
  final String status;
  final int modal;
  final int hasil;
  final String modalLabel;
  final String hasilLabel;
  final String nominalReturn;
  final double cardHeight;
  final VoidCallback onTap;

  const _TokenUsageCard({
    Key? key,
    required this.title,
    required this.owner,
    required this.status,
    required this.modal,
    required this.hasil,
    required this.modalLabel,
    required this.hasilLabel,
    required this.nominalReturn,
    required this.cardHeight,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const double radius = 12;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double gapM = (deviceHeight * 0.012).clamp(8.0, 14.0).toDouble();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: width * 0.74,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
          constraints: BoxConstraints(
            minHeight: cardHeight,
            maxHeight: cardHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Status badge with fixed height
              SizedBox(
                height: 44, // Fixed height untuk 2 baris title
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: status.contains('Selesai')
                            ? Colors.green.withOpacity(0.12)
                            : Colors.blue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: status.contains('Selesai')
                              ? darkGreen
                              : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),
              
              // Owner with fixed height
              SizedBox(
                height: 18,
                child: Text(
                  owner,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              SizedBox(height: gapM),

              // Metrics block: two bordered stat boxes
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$modal',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            modalLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              nominalReturn,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: darkGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            '$hasilLabel: ($hasil)',
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}