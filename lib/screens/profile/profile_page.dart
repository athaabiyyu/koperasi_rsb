import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/screens/profile/profile_header.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';

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
    
    final result = await Navigator.pushNamed(context, route);
    
    if (!mounted) return;
    
    if (result == true) {
      setState(() {}); // Trigger rebuild untuk update data
    }
    
    setState(() => _navigating = false);
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );

    // Perform logout
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.logout(
      keepCredentials: authProvider.rememberMe, // Keep if remember me is on
    );

    if (!mounted) return;

    // Close loading dialog
    Navigator.pop(context);

    if (success) {
      // Navigate to login page and clear all routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Gagal keluar',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName ?? 'User';
    final userRole = authProvider.userRole ?? 'BASIC';
    final isplatinum = userRole == 'PLATINUM';

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/member-reguler');
        return false;
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
            if (i == 3) return;
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
              ProfileHeader(
                name: userName,
                isplatinum: isplatinum,
              ),
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
              
              // Logout Button
              InkWell(
                onTap: () => _handleLogout(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
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
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keluar',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Keluar dari akun Anda',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
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