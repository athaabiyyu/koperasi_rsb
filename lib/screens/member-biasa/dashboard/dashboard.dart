import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/screens/member-biasa/dashboard/section/regular_header.dart';
import 'package:koperasi_rsb/widgets-global/card/transaction_history_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late double _deviceHeight;

  @override
  void initState() {
    super.initState();
    // Fetch topup history saat page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = _getTokenFromContext();
      if (token != null && token.isNotEmpty) {
        context.read<TopupProvider>().fetchTopupHistory(token);
      }
    });
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

  // ✅ Method untuk navigasi dengan smooth transition
  void _navigateWithTransition(int index) {
    if (!mounted) return;

    // Cegah navigasi ke page yang sama
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (index) {
      case 0:
        if (currentRoute == '/member-biasa') return;
        // Fade transition untuk dashboard (smooth tanpa arah)
        Navigator.pushReplacementNamed(context, '/member-biasa');
        break;

      case 1:
        if (currentRoute == '/my-project') return;
        // Slide dari kanan untuk my-project
        Navigator.pushReplacementNamed(context, '/my-project');
        break;

      case 2:
        if (currentRoute == '/wallet') return;
        // Slide dari kanan untuk wallet
        Navigator.pushReplacementNamed(context, '/wallet');
        break;

      case 3:
        if (currentRoute == '/profile') return;
        // Slide dari kanan untuk profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: lightGreen,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Default User';

    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: _navigateWithTransition, // ✅ Gunakan method baru
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegularHeader(userName: userName),
              SizedBox(height: _deviceHeight * 0.05),
              const TransactionHistorySection(
                variant: TransactionHistoryVariant.regular,
              ),
              SizedBox(height: _deviceHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}