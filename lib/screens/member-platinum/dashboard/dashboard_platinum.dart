import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/screens/proyek/project_detail.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
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

  final List<Map<String, dynamic>> _tokenUsage = const [
    {
      'title': 'Stand Telur Gulung',
      'owner': 'Budi Wijaya',
      'status': 'Proyek Berjalan',
      'modal': 10,
      'hasil': 2,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/telur/600/400',
    },
    {
      'title': 'Stand Pisang Nugget',
      'owner': 'Marlina Siahaan',
      'status': 'Proyek Selesai',
      'modal': 20,
      'hasil': 20,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/pisang/600/400',
    },
    {
      'title': 'Stand Crepes Azzura',
      'owner': 'Marlina Siahaan',
      'status': 'Proyek Berjalan',
      'modal': 20,
      'hasil': 7,
      'modalLabel': 'Jumlah Modal (Lot)',
      'hasilLabel': 'Perkiraan Hasil',
      'imageUrl': 'https://picsum.photos/seed/crepes/600/400',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = _getTokenFromContext();
      if (token != null && token.isNotEmpty) {
        context.read<TopupProvider>().fetchTopupHistory(token);
        // ignore: avoid_print
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
              Navigator.pushReplacementNamed(context, '/my-project');
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Penggunaan Token',
                style: GoogleFonts.poppins(
                  fontSize: _deviceWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/member-premium/token-usage');
                },
                child: Text(
                  'Lihat lainnya',
                  style: GoogleFonts.poppins(
                    color: darkGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
                  itemCount: _tokenUsage.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: _deviceWidth * 0.035),
                  itemBuilder: (context, index) {
                    final item = _tokenUsage[index];
                    final isSelesai = (item['status'] as String).contains(
                      'Selesai',
                    );
                    return _TokenUsageCard(
                      title: item['title'],
                      owner: item['owner'],
                      status: item['status'],
                      modal: item['modal'],
                      hasil: item['hasil'],
                      modalLabel: item['modalLabel'],
                      hasilLabel: item['hasilLabel'],
                      cardHeight: listHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailPage(
                              imageUrl: item['imageUrl'],
                              status: item['status'],
                              title: item['title'],
                              owner: item['owner'],
                              collectedToken: item['hasil'],
                              remainingDays: isSelesai ? 0 : 12,
                              maxToken: item['modal'],
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
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
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
              // Header: Owner + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Spacer(),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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
                    ),
                  ),
                ],
              ),

              SizedBox(height: gapM),

              // Title
              AutoSizeText(
                title,
                maxLines: 2,
                minFontSize: 11,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),
              Text(
                owner,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: gapM),

              // Metrics block: two bordered stat boxes
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
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
                            'Jumlah Penggunaan Token',
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
                        vertical: 10,
                        horizontal: 12,
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
                              'Rp 0',
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
                            'Return: ($hasil)',
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
