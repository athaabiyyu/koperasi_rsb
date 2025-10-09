import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/navigation/app_bottom_nav.dart';
import 'package:koperasi_rsb/widgets-global/transaction-history.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialogJoinPenyertaan.dart';
import 'package:koperasi_rsb/widgets-global/dialog/dialog-pilih-nominal-pembayaran.dart';
import 'package:koperasi_rsb/widgets-global/dialog/detail-pembayaran-awal.dart';
import 'package:koperasi_rsb/widgets-global/card/card-detail-pembayaran.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  // TODO: Ganti dengan data aktual dari backend / auth provider
  bool isPremium = false; // sementara diset true untuk demonstrasi

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (i) {
          if (i == 0) return; // already on Dashboard
          if (!mounted) return;
          switch (i) {
            case 1:
              Navigator.pushReplacementNamed(context, '/daftarProyek');
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Halaman Dompet belum tersedia')),
              );
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(),
            SizedBox(height: _deviceHeight * 0.01),
            // Card Riwayat Transaksi
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                    // Header: Judul + Tombol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: _deviceWidth * 0.01),
                          child: Text(
                            "Riwayat Transaksi",
                            style: TextStyle(
                              fontSize: _deviceWidth * 0.04,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            // Padding lebih kecil termasuk bagian atas sesuai permintaan
                            padding: EdgeInsets.symmetric(
                              horizontal: _deviceWidth * 0.015,
                              vertical: _deviceHeight * 0.004,
                            ),
                            visualDensity: const VisualDensity(
                              horizontal: -1,
                              vertical:
                                  -2, // membuat tinggi tombol lebih ringkas
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Tampilkan detail pembayaran khusus Simpanan Wajib saja
                            DetailPembayaranAwalMember.show(
                              context,
                              alertTitle: "Detail Pembayaran",
                              alertMessage:
                                  "Pastikan data pembayaran sudah benar.",
                              paymentTitle: "Pembayaran Simpanan Wajib",
                              paymentHeader: "Informasi Pembayaran",
                              paymentItems: [
                                PaymentItem(
                                    title: "Simpanan Wajib",
                                    price: "Rp 120.000"),
                              ],
                              totalPrice: "Rp 120.000",
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Pembayaran Simpanan Wajib dikonfirmasi")),
                                );
                              },
                            );
                          },
                          child: AutoSizeText(
                            "Bayar Simpanan Wajib",
                            style: TextStyle(
                                fontSize: _deviceWidth * 0.025,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            minFontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),

                    // List Transaksi + Divider antar item
                    Column(
                      children: [
                        TransactionItem(
                          title: "Simpanan Wajib",
                          date: "12 Agustus 2025",
                          amount: "Rp. 120.000",
                          isSuccess: false,
                          statusLabel: "Belum Membayar",
                        ),
                        const Divider(),
                        TransactionItem(
                          title: "Simpanan Pokok",
                          date: "12 Agustus 2024",
                          amount: "Rp. 120.000",
                          isSuccess: true,
                          statusLabel: "Berhasil",
                        ),
                        const Divider(),
                        TransactionItem(
                          title: "Simpanan Wajib",
                          date: "12 Agustus 2023",
                          amount: "Rp. 120.000",
                          isSuccess: true,
                          statusLabel: "Berhasil",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight * 0.02), // jarak ke bawah
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Container(
          width: _deviceWidth,
          padding: EdgeInsets.only(
            right: _deviceWidth * 0.05,
            left: _deviceWidth * 0.05,
            top: _deviceHeight * 0.03,
            bottom: _deviceHeight * 0.005,
          ),
          color: lightGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas: Nama, badge, avatar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: _deviceWidth * 0.06,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: _deviceHeight * 0.005),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Kita batasi area nama+status agar tidak memakan space avatar.
                            // constraints.maxWidth di sini sudah terbatas oleh Expanded di atas.
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                // Sisakan ruang minimum untuk avatar (kurang lebih radius*2 + margin). Karena avatar berada di luar Expanded, cukup pastikan text truncate.
                                maxWidth: constraints.maxWidth,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Nama dibatasi dan ellipsis
                                  Flexible(
                                    child: AutoSizeText(
                                      "Andi Hidayat", // TODO: ganti dengan nama dinamis
                                      style: TextStyle(
                                        fontSize: _deviceWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: _deviceWidth * 0.02),
                                  // Status badge selalu di samping nama selama masih ada ruang, kalau terlalu sempit akan terpotong duluan oleh Flexible name.
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _deviceWidth * 0.02,
                                        vertical: _deviceHeight * 0.002,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPremium
                                            ? Colors.green
                                            : const Color(0xFFFFF0E6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isPremium
                                              ? Colors.green.shade700
                                              : Colors.orange,
                                        ),
                                      ),
                                      child: Text(
                                        isPremium
                                            ? "Member Premium"
                                            : "Member Reguler", // TODO: ganti dengan status dinamis
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isPremium
                                              ? Colors.white
                                              : Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Spasi agar tidak terlalu mepet dengan avatar
                  SizedBox(width: _deviceWidth * 0.075),
                  // Avatar user
                  CircleAvatar(
                    radius: _deviceWidth * 0.08,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                  ),
                ],
              ),

              SizedBox(height: _deviceHeight * 0.03),

              // Card Ringkasan Saldo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.008),
                child: Row(
                  children: [
                    _buildSummaryCard("Simpanan Pokok", "Rp 50.000"),
                    SizedBox(width: _deviceWidth * 0.02),
                    _buildSummaryCard("Simpanan Wajib", "Rp 120.000"),
                    SizedBox(width: _deviceWidth * 0.02),
                    // _buildSummaryCard("Sisa Hasil Usaha", "Rp 5.000.000"),
                  ],
                ),
              ),

              // Banner join penyertaan
              Container(
                width: _deviceWidth,
                padding: EdgeInsets.all(_deviceWidth * 0.03),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(_deviceWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon custom dari assets
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              "assets/icons/join_penyertaan.png",
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isPremium) ...[
                                  AutoSizeText(
                                    "Ingin Mengikuti Penyertaan?",
                                    style: TextStyle(
                                      fontSize: _deviceWidth * 0.03,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    minFontSize: 10,
                                  ),
                                  SizedBox(height: 12), // jarak antar teks
                                ],
                                AutoSizeText(
                                  isPremium
                                      ? "Top up saldo minimal dimulai dari Rp500.000"
                                      : "Nikmati Keistimewaan Hanya dengan minimal Rp 500.000",
                                  style: TextStyle(
                                    fontSize: _deviceWidth * 0.03,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  minFontSize: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _deviceHeight * 0.015),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              vertical: _deviceHeight * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            showDialogJoinPenyertaan(
                              context: context,
                              onJoin: () {
                                // Tampilkan dialog pilih nominal pembayaran setelah join tanpa mengubah file dialogJoinPenyertaan.
                                showDialogPilihNominalPembayaran(context);
                              },
                              onCancel: () {
                                // Opsional: aksi ketika batal
                              },
                            );
                          },
                          child: Text(
                            isPremium ? "Top Up Penyertaan" : "Join Penyertaan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _deviceHeight * 0.015,
          horizontal: _deviceWidth * 0.025,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(
                fontSize: _deviceWidth * 0.027,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _deviceHeight * 0.01),
            AutoSizeText(
              amount,
              style: TextStyle(
                fontSize: _deviceWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(height: _deviceHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
