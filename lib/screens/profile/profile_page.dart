import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/screens/profile/profile_header.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _navigating = false;

  Future<void> _navigate(BuildContext context, String route) async {
    if (_navigating) return; // debounce
    setState(() => _navigating = true);
    await Navigator.pushNamed(context, route);
    if (!mounted) return;
    setState(() => _navigating = false);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/member-reguler');
        return false; // mencegah pop default
      },
      child: Scaffold(
        backgroundColor: lightGreen,
        appBar: AppBar(
          title: const Text('Profil'),
          backgroundColor: lightGreen,
          elevation: 0,
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: 3,
          onItemSelected: (i) {
            if (i == 3) return; // already on Profil
            if (!mounted) return;
            switch (i) {
              case 0:
                Navigator.pushReplacementNamed(context, '/member-reguler');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/my-project');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/wallet');
                break;
            }
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(name: 'budiono siregar', isPremium: true),
              const SizedBox(height: 24),
              _menuCard(
                context,
                icon: Icons.person,
                title: 'Data Diri',
                subtitle: 'NIK, nama lengkap, tempat & tanggal lahir',
                route: '/profile/data-diri',
              ),
              const SizedBox(height: 16),
              _menuCard(
                context,
                icon: Icons.home_rounded,
                title: 'Alamat',
                subtitle: 'Provinsi, kota/kabupaten, kecamatan & detail',
                route: '/profile/alamat',
              ),
              const SizedBox(height: 16),
              _menuCard(
                context,
                icon: Icons.file_present_rounded,
                title: 'Dokumen Pelengkap',
                subtitle: 'Upload foto KTP dan foto diri',
                route: '/profile/dokumen',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      onTap: _navigating ? null : () => _navigate(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: strokeGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: darkGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            _navigating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
