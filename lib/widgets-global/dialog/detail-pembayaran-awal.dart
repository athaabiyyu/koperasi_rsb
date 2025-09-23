import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/pop-up-alert.dart';

class DetailPembayaranAwalMember extends StatelessWidget {
  final String alertTitle;
  final String alertMessage;
  final String paymentTitle;
  final String paymentHeader;
  final List<PaymentItem> paymentItems;
  final String totalPrice;
  final VoidCallback onPressed;

  const DetailPembayaranAwalMember({
    Key? key,
    required this.alertTitle,
    required this.alertMessage,
    required this.paymentTitle,
    required this.paymentHeader,
    required this.paymentItems,
    required this.totalPrice,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black.withOpacity(0.7),
      
      child: SizedBox(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: PopUpAlert(
                title: alertTitle,
                message: alertMessage,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: CardDetailPembayaran(
                title: paymentTitle,
                headerText: paymentHeader,
                items: paymentItems,
                totalPrice: totalPrice,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Static method untuk show dialog
  static void show(BuildContext context,
      {required String alertTitle,
      required String alertMessage,
      required String paymentTitle,
      required String paymentHeader,
      required List<PaymentItem> paymentItems,
      required String totalPrice,
      required VoidCallback onPressed}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return DetailPembayaranAwalMember(
          alertTitle: alertTitle,
          alertMessage: alertMessage,
          paymentTitle: paymentTitle,
          paymentHeader: paymentHeader,
          paymentItems: paymentItems,
          totalPrice: totalPrice,
          onPressed: onPressed,
        );
      },
    );
  }
}
