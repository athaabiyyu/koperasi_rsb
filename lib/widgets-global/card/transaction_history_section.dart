import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/providers/topup_provider.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:provider/provider.dart';

enum TransactionHistoryVariant { premium, regular }

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({
    super.key,
    required this.variant,
    this.itemsPerPageForRegular = 3,
    this.maxItemsForPremium = 6,
  });

  final TransactionHistoryVariant variant;
  final int itemsPerPageForRegular;
  final int maxItemsForPremium;

  bool get _isPremium => variant == TransactionHistoryVariant.premium;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<TopupProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(deviceWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(color: darkGreen),
              ),
            ),
          );
        }

        if (provider.errorMessage != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(deviceWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  provider.errorMessage!,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                ),
              ),
            ),
          );
        }

        final allTransactions = provider.topups.map((topup) {
          return TransactionItem(
            title: topup.displayTransactionType,
            date: topup.displayDate,
            amount: topup.displayAmount,
            isSuccess: topup.isSuccess,
            statusLabel: topup.isPending
                ? 'Menunggu Konfirmasi'
                : topup.isSuccess
                ? 'Berhasil'
                : 'Gagal',
          );
        }).toList();

        if (allTransactions.isEmpty) {
          return _SectionContainer(
            deviceWidth: deviceWidth,
            deviceHeight: deviceHeight,
            // Explicitly hide pay button when list is empty (both variants)
            isPremium: false,
            title: 'Riwayat Transaksi',
            child: Center(
              child: Text(
                'Belum ada transaksi',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            ),
          );
        }

        if (_isPremium) {
          final transactions = allTransactions
              .take(maxItemsForPremium)
              .toList();
          return _SectionContainer(
            deviceWidth: deviceWidth,
            deviceHeight: deviceHeight,
            // Hide the pay button for premium dashboard as requested
            isPremium: false,
            title: 'Riwayat Transaksi',
            child: Column(
              children: [
                ...List.generate(
                  transactions.length,
                  (index) => Column(
                    children: [
                      transactions[index],
                      if (index != transactions.length - 1) const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Regular with pagination
          return StatefulBuilder(
            builder: (context, setState) {
              int currentPage = 1;
              final totalPages =
                  (allTransactions.length / itemsPerPageForRegular).ceil();
              final startIndex = (currentPage - 1) * itemsPerPageForRegular;
              final endIndex =
                  (startIndex + itemsPerPageForRegular) > allTransactions.length
                  ? allTransactions.length
                  : (startIndex + itemsPerPageForRegular);
              final visibleTransactions = allTransactions.sublist(
                startIndex,
                endIndex,
              );

              return _SectionContainer(
                deviceWidth: deviceWidth,
                deviceHeight: deviceHeight,
                isPremium: false,
                title: 'Riwayat Transaksi',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(
                        visibleTransactions.length,
                        (index) => Column(
                          children: [
                            visibleTransactions[index],
                            if (index != visibleTransactions.length - 1)
                              const Divider(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: currentPage > 1
                                ? () => setState(() => currentPage--)
                                : null,
                            child: const Text('Previous'),
                          ),
                          ...List.generate(totalPages, (index) {
                            final page = index + 1;
                            final isCurrent = page == currentPage;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: GestureDetector(
                                onTap: () => setState(() => currentPage = page),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? darkGreen
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: darkGreen),
                                  ),
                                  child: Text(
                                    '$page',
                                    style: TextStyle(
                                      color: isCurrent
                                          ? Colors.white
                                          : darkGreen,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          TextButton(
                            onPressed: currentPage < totalPages
                                ? () => setState(() => currentPage++)
                                : null,
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
    required this.deviceWidth,
    required this.deviceHeight,
    required this.isPremium,
    required this.title,
    required this.child,
  });

  final double deviceWidth;
  final double deviceHeight;
  final bool isPremium;
  final String title;
  final Widget child;

  void _showPaymentDialog(BuildContext context) {
    DetailPembayaranAwalMember.show(
      context,
      alertTitle: 'Detail Pembayaran',
      alertMessage: 'Pastikan data pembayaran sudah benar.',
      paymentTitle: 'Pembayaran Simpanan Wajib',
      paymentHeader: 'Informasi Pembayaran',
      paymentItems: [PaymentItem(title: 'Simpanan Wajib', price: 'Rp 120.000')],
      totalPrice: 'Rp 120.000',
      onPressed: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran diproses'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(deviceWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: deviceWidth * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                  ),
                ),
                SizedBox(width: deviceWidth * 0.02),
                if (isPremium)
                  Flexible(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.025,
                          vertical: deviceHeight * 0.008,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _showPaymentDialog(context),
                      child: AutoSizeText(
                        'Bayar Simpanan Wajib',
                        style: GoogleFonts.poppins(
                          fontSize: deviceWidth * 0.032,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        minFontSize: 11,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.015),
            const Divider(height: 1),
            SizedBox(height: deviceHeight * 0.01),
            child,
          ],
        ),
      ),
    );
  }
}
