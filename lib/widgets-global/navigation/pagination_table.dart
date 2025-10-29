import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol < di kiri dengan latar bulat semi-transparan
        Container(
          decoration: BoxDecoration(
            color: darkGreen.withOpacity(currentPage > 1 ? 0.1 : 0.05),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            color: currentPage > 1 ? darkGreen : Colors.grey,
            onPressed: currentPage > 1 ? onPrevious : null,
            tooltip: 'Halaman Sebelumnya',
            iconSize: 24,
          ),
        ),

        // Indikator halaman di tengah
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(totalPages, (index) {
                final page = index + 1;
                final bool isCurrent = page == currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        page.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: isCurrent ? darkGreen : Colors.grey,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isCurrent)
                        Container(
                          width: 40,
                          height: 2,
                          color: darkGreen,
                        )
                      else
                        const SizedBox(height: 2),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // Tombol > di kanan dengan latar bulat semi-transparan
        Container(
          decoration: BoxDecoration(
            color: darkGreen.withOpacity(currentPage < totalPages ? 0.1 : 0.05),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_right),
            color: currentPage < totalPages ? darkGreen : Colors.grey,
            onPressed: currentPage < totalPages ? onNext : null,
            tooltip: 'Halaman Berikutnya',
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}
