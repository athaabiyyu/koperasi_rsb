import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/screens/kontak%20admin/kontak-admin.dart';
import 'package:koperasi_rsb/screens/dompet/dompet.dart';
import 'package:koperasi_rsb/screens/profile/alamat_page.dart';
import 'package:koperasi_rsb/screens/profile/data_diri_page.dart';
import 'package:koperasi_rsb/screens/profile/dokumen_pelengkap_page.dart';
import 'package:koperasi_rsb/screens/profile/profile_page.dart';
import 'package:koperasi_rsb/screens/proyek/my_project.dart';
import 'package:koperasi_rsb/screens/member-platinum/dashboard/dashboard_platinum.dart';
import 'package:koperasi_rsb/screens/member-platinum/detail-penggunaan-token/detail_penggunaan_token.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:koperasi_rsb/providers/wallet_provider.dart';
import 'package:koperasi_rsb/screens/auth/login/login.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page1.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page2.dart';
import 'package:koperasi_rsb/screens/auth/regis/register-page3.dart';
import 'package:koperasi_rsb/screens/otp/verify_otp.dart';
import 'package:koperasi_rsb/splash_screen.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/screens/member-biasa/dashboard/dashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:koperasi_rsb/widgets-global/form/muncul-rekening-member-biasa.dart';

Future<void> main() async {
  // Pastikan dotenv dimuat sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TopupProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        title: 'Koperasi RSB',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightGreen),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/registration1': (context) => RegistrationPage1(),
          '/registration2': (context) => const RegistrationPage2(),
          '/registration3': (context) => RegistrationPage3(),
          '/dashboard': (context) => const DashboardPage(),
          '/member-reguler': (context) => const DashboardPage(),
          '/member-platinum': (context) => const PremiumDashboardPage(),
          '/my-project': (context) => const MyProjectPage(),
          '/wallet': (context) => const DompetPage(),
          '/profile': (context) => const ProfilePage(),
          '/profile/data-diri': (context) => const DataDiriPage(),
          '/profile/alamat': (context) => const AlamatPage(),
          '/profile/dokumen': (context) => const DokumenPelengkapPage(),
          '/profile/hubungi-admin': (context) => const KontakAdminPage(),
          '/payment-form': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            
            print('=== ROUTE /payment-form ===');
            print('Arguments: $args');
            
            return MunculRekeningMemberBiasa(
              nominalPenyertaan: args?['nominalPenyertaan'] as int?,
              totalPembayaran: args?['totalPembayaran'] as int?,
              formattedNominal: args?['formattedNominal'] as String?,
              isTopUpOnly: args?['isTopUpOnly'] as bool? ?? false,
              isSimpananWajib: args?['isSimpananWajib'] as bool? ?? false,
              isPenyertaan: args?['isPenyertaan'] as bool? ?? false,
            );
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/member-premium/token-usage') {
            return MaterialPageRoute(
              builder: (context) => const TokenUsageListPage(),
            );
          }
          if (settings.name == '/verify-otp') {
            final args = settings.arguments as Map<String, dynamic>?;

            if (args == null ||
                !args.containsKey('noHp') ||
                !args.containsKey('password')) {
              return MaterialPageRoute(builder: (context) => const LoginPage());
            }

            return MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                noHp: args['noHp'] as String,
                password: args['password'] as String,
              ),
            );
          }

          return null;
        },
      ),
    );
  }
}