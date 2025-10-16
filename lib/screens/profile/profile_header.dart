import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final bool isplatinum;
  late double _deviceWidth;
  late double _deviceHeight;

  ProfileHeader({
    super.key,
    required this.name,
    this.isplatinum = false,
  });

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: strokeGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto profil + icon edit
            Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: () {
                      // TODO: Aksi ketika tombol ganti foto diklik
                      // Misal: tampilkan dialog pilih foto
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 12),
      
            // Nama user
            AutoSizeText(
              name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              minFontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
      
            // Status member
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.025,
                vertical: _deviceHeight * 0.004,
              ),
              decoration: BoxDecoration(
                color: isplatinum ? Colors.green : const Color(0xFFFFF0E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isplatinum ? Colors.green.shade700 : orange,
                ),
              ),
              child: Text(
                isplatinum ? "Member Platinum" : "Member Reguler",
                style: GoogleFonts.poppins(
                  fontSize: _deviceWidth * 0.020,
                  color: isplatinum ? Colors.white : orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
