import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakAdminPage extends StatelessWidget {
  const KontakAdminPage({super.key});

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri.parse('mailto:$email');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kontak Admin',
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Butuh bantuan apa\nhari ini ?',
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(35),
                  child: ListView(
                    children: [
                      // Contact Card - WhatsApp
                      _buildContactCard(
                        icon: Icons.people,
                        iconColor: darkGreen,
                        title: 'No Wa',
                        subtitle: '081216773680',
                        onTap: () => _launchWhatsApp('081216773680'),
                      ),
                      const SizedBox(height: 20),

                      // Contact Card - Email
                      _buildContactCard(
                        icon: Icons.email,
                        iconColor: const Color(0xFFFF9800),
                        title: 'Email',
                        subtitle: 'alimurrofid77@gmail.com',
                        onTap: () => _launchEmail('alimurrofid77@gmail.com'),
                      ),
                      const SizedBox(height: 20),

                      // Contact Card - Additional
                      _buildContactCard(
                        icon: Icons.email,
                        iconColor: const Color(0xFFFF9800),
                        title: 'Email',
                        subtitle: 'support@koperasi.com',
                        onTap: () => _launchEmail('support@koperasi.com'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
