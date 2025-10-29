// lib/widgets/dialogs/sign_contract_dialog.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignContractDialog extends StatefulWidget {
  final String projectId;
  final VoidCallback onSuccess;

  const SignContractDialog({
    super.key,
    required this.projectId,
    required this.onSuccess,
  });

  @override
  State<SignContractDialog> createState() => _SignContractDialogState();
}

class _SignContractDialogState extends State<SignContractDialog> {
  bool _isAgreed = false;
  bool _isLoading = false;

  Future<void> _handleSign() async {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement signature capture and API call
      // For now, just simulate delay
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kontrak berhasil ditandatangani'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menandatangani kontrak: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Tanda Tangani Kontrak',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Silakan baca dan setujui syarat dan ketentuan kontrak perjanjian sebelum menandatangani.',
              style: GoogleFonts.roboto(fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Contract preview (placeholder)
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preview Kontrak',
                      style: GoogleFonts.roboto(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Agreement checkbox
            CheckboxListTile(
              value: _isAgreed,
              onChanged: (value) {
                setState(() => _isAgreed = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Saya telah membaca dan menyetujui syarat dan ketentuan kontrak perjanjian',
                style: GoogleFonts.roboto(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Batal',
            style: GoogleFonts.roboto(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSign,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Tanda Tangani',
                  style: GoogleFonts.roboto(),
                ),
        ),
      ],
    );
  }
}

// Helper function to show dialog
Future<void> showSignContractDialog(
  BuildContext context, {
  required String projectId,
  required VoidCallback onSuccess,
}) {
  return showDialog(
    context: context,
    builder: (context) => SignContractDialog(
      projectId: projectId,
      onSuccess: onSuccess,
    ),
  );
}