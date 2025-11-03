import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/utils/currency_helper.dart';

Future<bool?> showConfirmPurchaseDialog(
  BuildContext context, {
  required String projectTitle,
  required int tokens,
  required int pricePerToken,
  required int walletBalance,
  String paymentMethodName = 'Saldo Dompet',
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final media = MediaQuery.of(ctx);
      final viewInsets = media.viewInsets.bottom;
      final screenHeight = media.size.height;
      final screenWidth = media.size.width;
      // Keep dialog width within viewport while capping for large screens
      final double maxDialogWidth = (screenWidth - 40).clamp(280.0, 520.0);
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: viewInsets),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxDialogWidth,
              maxHeight: (screenHeight - viewInsets - 48).clamp(
                320.0,
                screenHeight,
              ),
            ),
            child: SafeArea(
              // In dialogs, we usually keep a bit of outer spacing via insetPadding already
              top: false,
              bottom: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _ConfirmPurchaseContent(
                  projectTitle: projectTitle,
                  tokens: tokens,
                  pricePerToken: pricePerToken,
                  walletBalance: walletBalance,
                  paymentMethodName: paymentMethodName,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _ConfirmPurchaseContent extends StatefulWidget {
  const _ConfirmPurchaseContent({
    required this.projectTitle,
    required this.tokens,
    required this.pricePerToken,
    required this.walletBalance,
    required this.paymentMethodName,
  });

  final String projectTitle;
  final int tokens;
  final int pricePerToken;
  final int walletBalance;
  final String paymentMethodName;

  @override
  State<_ConfirmPurchaseContent> createState() =>
      _ConfirmPurchaseContentState();
}

class _ConfirmPurchaseContentState extends State<_ConfirmPurchaseContent> {
  bool _agree = false;
  bool _walletSelected = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.tokens * widget.pricePerToken;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Konfirmasi Pembelian',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
          const Divider(height: 20),

          // Warning banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA000)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Mohon cek kembali data Anda. Pastikan semua data sudah benar sebelum melanjutkan transaksi.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Info rows
          _InfoRow(label: 'Proyek', value: widget.projectTitle),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Jumlah Koin Dibeli',
            value: '${widget.tokens} Token',
          ),
          const SizedBox(height: 8),
          _InfoRow(label: 'Metode Pembayaran', value: widget.paymentMethodName),

          const SizedBox(height: 16),
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          // Wallet card selection
          InkWell(
            onTap: () => setState(() => _walletSelected = true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _walletSelected ? darkGreen : const Color(0xFFB8E6CC),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.paymentMethodName,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyUtils.formatRupiah(widget.walletBalance),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _walletSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: _walletSelected ? darkGreen : Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Agreement checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v ?? false),
                  side: const BorderSide(color: darkGreen),
                  activeColor: darkGreen,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    'Saya menyetujui pembelian koin di proyek ini dan telah membaca dan menyetujui isi prospektus serta memahami risiko atas keputusan penyertaan yang saya buat.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Pay button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _agree && _walletSelected
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: Text(
                'Bayar${total > 0 ? ' • ' + CurrencyUtils.formatRupiah(total) : ''}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }
}
