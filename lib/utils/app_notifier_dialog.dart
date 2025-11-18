import 'package:flutter/material.dart';
import 'package:koperasi_rsb/utils/app_navigator.dart';

class AppNotifierDialog {
  static Future<void> success({
    required String message,
    String title = 'Berhasil',
  }) async {
    return _show(
      title: title,
      message: message,
      color: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static Future<void> error({
    required String message,
    String title = 'Gagal',
  }) async {
    return _show(
      title: title,
      message: message,
      color: Colors.red,
      icon: Icons.error_outline,
    );
  }

  static Future<void> _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) async {
    final ctx =
        AppNavigator.key.currentState?.overlay?.context ??
        AppNavigator.key.currentContext;
    if (ctx == null) {
      return; // no context, silently ignore; provider may fallback to snackbar if set
    }

    // If a dialog is already visible, dismiss it first to avoid stacking
    if (Navigator.of(ctx, rootNavigator: true).canPop()) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }

    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (context) {
        // Auto-close after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(message),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
