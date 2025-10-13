import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final bool isplatinum;
  
  const ProfileHeader({
    super.key, 
    required this.name, 
    this.isplatinum = false, // ⭐ UPDATED: Default false supaya lebih aman
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: strokeGray),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18, 
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis, // ⭐ TAMBAHAN: Handle long names
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, 
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isplatinum ? darkGreen : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isplatinum ? 'Member Platinum' : 'Member Reguler',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}