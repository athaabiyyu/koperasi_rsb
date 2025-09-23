import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';

class PaymentItem {
  final String title;
  final String price;

  PaymentItem({
    required this.title,
    required this.price,
  });
}

class CardDetailPembayaran extends StatelessWidget {
  final String title;
  final String headerText;
  final List<PaymentItem> items;
  final String totalPrice;
  final VoidCallback onPressed;

  const CardDetailPembayaran({
    Key? key,
    required this.title,
    required this.headerText,
    required this.items,
    required this.totalPrice,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.info_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: deviceWidth * 0.05),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // List item pembayaran
                  ...items.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Expanded(
                              // 👈 biar teks bisa wrap
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.price,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: secGrayFont,
                      thickness: 0.15,
                      height: 20,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        totalPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Button
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
              child: SizedBox(
                width: deviceWidth * 0.75,
                height: 55,
                child: CustomButton(
                  text: "LANJUTKAN PEMBAYARAN",
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
