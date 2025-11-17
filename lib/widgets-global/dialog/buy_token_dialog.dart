import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/utils/currency_helper.dart';

Future<int?> showBuyTokenDialog(
  BuildContext context, {
  required int remaining,
  required int pricePerToken,
  required int maxPurchase,
}) {
  // Centered dialog instead of bottom sheet, as requested
  return showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final media = MediaQuery.of(ctx);
      final viewInsets = media.viewInsets.bottom;
      final screenHeight = media.size.height;
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: MediaQuery.removeViewInsets(
          context: ctx,
          removeBottom: true,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: viewInsets),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 480,
                // Keep dialog within viewport height even with keyboard
                maxHeight: (screenHeight - viewInsets - 48).clamp(
                  180.0,
                  screenHeight,
                ),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: _BuyTokenDialog(
                    remaining: remaining,
                    pricePerToken: pricePerToken,
                    maxPurchase: maxPurchase,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _BuyTokenDialog extends StatefulWidget {
  const _BuyTokenDialog({
    required this.remaining,
    required this.pricePerToken,
    required this.maxPurchase,
  });

  final int remaining;
  final int pricePerToken;
  final int maxPurchase;

  @override
  State<_BuyTokenDialog> createState() => _BuyTokenDialogState();
}

class _BuyTokenDialogState extends State<_BuyTokenDialog> {
  late final TextEditingController _controller;
  int _count = 1;
  String? _warning;

  @override
  void initState() {
    super.initState();
    _count = widget.remaining > 0 ? 1 : 0;
    _controller = TextEditingController(text: _count.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clampAndWarnIfNeeded() {
    final maxAllowed = (widget.remaining < widget.maxPurchase)
        ? widget.remaining
        : widget.maxPurchase;

    int newCount = _count;
    String? warn;

    if (newCount < 0) newCount = 0;

    if (newCount > maxAllowed) {
      // Prioritize message depending on which limit is hit first
      if (newCount > widget.remaining &&
          widget.remaining <= widget.maxPurchase) {
        warn =
            'Jumlah melebihi sisa token. Diatur menjadi ${widget.remaining}.';
      } else {
        warn =
            'Jumlah melebihi maksimal pembelian (${widget.maxPurchase}). Diatur menjadi $maxAllowed.';
      }
      newCount = maxAllowed;
    }

    setState(() {
      _count = newCount;
      _controller.text = _count.toString();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _warning = warn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _count * widget.pricePerToken;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Mau beli berapa Token?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final bool isNarrow = maxW < 340;
            final double gap = isNarrow ? 8.0 : 12.0;
            final double inputWidth = ((maxW * 0.32).clamp(
              96.0,
              140.0,
            )).toDouble();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onPressed: _count > 1
                      ? () {
                          setState(() {
                            _count--;
                            _controller.text = _count.toString();
                            _warning = null;
                          });
                        }
                      : null,
                  child: const Icon(Icons.remove, color: Colors.red),
                ),
                SizedBox(width: gap),
                SizedBox(
                  width: inputWidth,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: darkGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val.replaceAll('.', '')) ?? 0;
                      setState(() => _count = parsed);
                      _clampAndWarnIfNeeded();
                    },
                  ),
                ),
                SizedBox(width: gap),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: darkGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    final maxAllowed = (widget.remaining < widget.maxPurchase)
                        ? widget.remaining
                        : widget.maxPurchase;
                    if (_count < maxAllowed) {
                      setState(() {
                        _count++;
                        _controller.text = _count.toString();
                      });
                      _clampAndWarnIfNeeded();
                    } else {
                      _clampAndWarnIfNeeded();
                    }
                  },
                  child: const Icon(Icons.add, color: darkGreen),
                ),
              ],
            );
          },
        ),
        if (_warning != null) ...[
          const SizedBox(height: 8),
          Text(
            _warning!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nominal dalam Rupiah',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              CurrencyUtils.formatRupiah(total),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: darkGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
            onPressed: _count > 0
                ? () {
                    Navigator.of(context).pop(_count);
                  }
                : null,
            child: const Text('Selanjutnya'),
          ),
        ),
      ],
    );
  }
}
