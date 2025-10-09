import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

/// Simple reusable dialog widget
class DialogPenyertaan extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? amount;
  final List<String>? bulletPoints;
  final Widget? content;
  final String positiveText;
  final String? negativeText;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final bool dismissible;
  final bool showCloseButton;
  final IconData? titleIcon;

  const DialogPenyertaan({
    Key? key,
    required this.title,
    this.subtitle,
    this.amount,
    this.bulletPoints,
    this.content,
    this.positiveText = 'OK',
    this.negativeText,
    this.onPositive,
    this.onNegative,
    this.dismissible = true,
    this.showCloseButton = true,
    this.titleIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => dismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header dengan close button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon dan Title section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon container
                          if (titleIcon != null) ...[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                titleIcon!,
                                color: orange,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          
                          // Title
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: orange,
                            ),
                          ),
                          
                          // Subtitle
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: grayFont,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Close button
                    if (showCloseButton)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (onNegative != null) onNegative!();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: grayFont,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount display
                    if (amount != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        amount!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.black87,
                        ),
                      ),
                    ],

                    // Bullet points
                    if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ...bulletPoints!.map((point) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bullet point
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 12),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // Text content
                            Expanded(
                              child: Text(
                                point,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],

                    // Custom content
                    if (content != null) ...[
                      const SizedBox(height: 16),
                      content!,
                    ],
                  ],
                ),
              ),

              // Button section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    // Positive button (always full width)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onPositive != null) onPositive!();
                        },
                        child: Text(
                          positiveText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    // Negative button (if provided)
                    if (negativeText != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: grayFont.withOpacity(0.3)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onNegative != null) onNegative!();
                          },
                          child: Text(
                            negativeText!,
                            style: GoogleFonts.poppins(
                              color: grayFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper untuk memudahkan pemanggilan dialog Join Penyertaan
Future<T?> showDialogJoinPenyertaan<T>({
  required BuildContext context,
  String? amount = "RP.500.000",
  VoidCallback? onJoin,
  VoidCallback? onCancel,
  bool dismissible = true,
}) {
  final List<String> defaultBulletPoints = [
    "Pantau perkembangan penyertaan kamu dengan mudah melalui fitur Dashboard Platinum",
    "Memudahkan kamu untuk memantau saldo simpanan, melakukan top up kapan saja, dan menarik dana dengan cepat dengan fitur Dompet Platinum",
    "Kamu bisa melakukan trading di proyek proyek koperasi",
    "Dapatkan keuntungan! Sebanyak banyaknya dari hasil trading di proyek proyek",
  ];

  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: (ctx) => DialogPenyertaan(
      title: "JOIN PENYERTAAN",
      subtitle: "Mulai dari",
      amount: amount,
      bulletPoints: defaultBulletPoints,
      positiveText: "Gabung Sekarang",
      titleIcon: Icons.inventory_2_outlined,
      onPositive: onJoin,
      onNegative: onCancel,
      dismissible: dismissible,
      showCloseButton: true,
    ),
  );
}

/// Helper untuk dialog penyertaan umum (existing functionality)
Future<T?> showDialogPenyertaan<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  String? amount,
  List<String>? bulletPoints,
  Widget? content,
  String positiveText = 'OK',
  String? negativeText,
  VoidCallback? onPositive,
  VoidCallback? onNegative,
  bool dismissible = true,
  bool showCloseButton = false,
  IconData? titleIcon,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: (ctx) => DialogPenyertaan(
      title: title,
      subtitle: subtitle,
      amount: amount,
      bulletPoints: bulletPoints,
      content: content,
      positiveText: positiveText,
      negativeText: negativeText,
      onPositive: onPositive,
      onNegative: onNegative,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      titleIcon: titleIcon,
    ),
  );
}