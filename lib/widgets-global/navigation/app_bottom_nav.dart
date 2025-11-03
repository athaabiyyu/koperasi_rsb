import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onItemSelected;
  final String? userRole; // Tambahkan parameter userRole

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onItemSelected,
    this.userRole, // Tambahkan di constructor
  });

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    // Responsive sizes
    final double boxSize = (_deviceWidth * 0.11).clamp(34.0, 48.0);
    final double iconSize = (_deviceWidth * 0.068).clamp(22.0, 28.0);

    void _handleTap(int index) {
      // If parent provides a handler, use it to keep pages in control
      if (onItemSelected != null) {
        onItemSelected!(index);
        return;
      }

      // Default routing fallback (role-aware for Home & Proyek tabs)
      final String role = (userRole ?? 'BASIC').toUpperCase();
      final bool isPlatinum = role == 'PLATINUM';

      switch (index) {
        case 0:
          // Beranda: arahkan ke dashboard sesuai role
          Navigator.pushReplacementNamed(
            context,
            isPlatinum ? '/member-platinum' : '/member-reguler',
          );
          break;
        case 1:
          // Proyek: Platinum ke daftar semua proyek, Basic ke proyek milik user
          Navigator.pushReplacementNamed(
            context,
            isPlatinum ? '/project-list' : '/my-project',
          );
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/wallet');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: darkGreen,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: _deviceHeight * 0.020,
          bottom: _deviceHeight * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              imagePath: 'assets/icons/home-icon.png',
              label: 'Beranda',
              selected: currentIndex == 0,
              onTap: () => _handleTap(0),
              boxSize: boxSize,
              iconSize: iconSize,
            ),
            _NavItem(
              imagePath: 'assets/icons/add-project-icon.png',
              label: 'Proyek',
              selected: currentIndex == 1,
              onTap: () => _handleTap(1),
              boxSize: boxSize,
              iconSize: iconSize,
            ),
            _NavItem(
              imagePath: 'assets/icons/dompet-icon.png',
              label: 'Dompet',
              selected: currentIndex == 2,
              onTap: () => _handleTap(2),
              boxSize: boxSize,
              iconSize: iconSize,
            ),
            _NavItem(
              imagePath: 'assets/icons/profile-icon.png',
              label: 'Profil',
              selected: currentIndex == 3,
              onTap: () => _handleTap(3),
              boxSize: boxSize,
              iconSize: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double boxSize;
  final double iconSize;

  const _NavItem({
    required this.imagePath,
    required this.label,
    required this.selected,
    this.onTap,
    required this.boxSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  color: selected ? darkGreen : Colors.white,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
