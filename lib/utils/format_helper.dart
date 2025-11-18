import 'package:koperasi_rsb/models/topup_model.dart';

class FormatHelper {
  // Format nominal ke Rupiah
  static String formatRupiah(int nominal) {
    return 'Rp ${nominal.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  // Format tanggal
  static String formatTanggal(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Format tanggal lengkap dengan jam
  static String formatTanggalLengkap(DateTime date) {
    return '${formatTanggal(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Parse string rupiah ke int
  static int parseRupiah(String rupiahString) {
    return int.tryParse(
      rupiahString
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim(),
    ) ?? 0;
  }

  // Convert TopupModel ke Map untuk table
  Map<String, String> topupToTableData(TopupModel topup) {
    return {
      'tanggal': FormatHelper.formatTanggal(topup.createdAt),
      'nama': topup.user?.name ?? topup.nama ?? '-',
      'nominal': topup.displayAmount,
      'jenis': topup.displayTransactionType,
      'status': topup.displayStatus,
      'bukti pembayaran': topup.hasBuktiPembayaran ? 'Lihat Dokumen' : 'Dokumen belum Tersedia',
      'bukti_pembayaran_url': topup.buktiPembayaranUrl ?? '',
    };
  }

  // Filter by status dan hanya untuk jenis "Penarikan"
  List<Map<String, String>> filterByStatus(
    List<TopupModel> topupList,
    String status,
  ) {
    // Filter hanya transaksi dengan jenis "Penarikan" dan status tertentu
    final filtered = topupList.where((topup) {
      final jenis = topup.jenis?.toLowerCase() ?? '';
      
      // Cek apakah jenis adalah "Penarikan" atau "Penarikan Saldo"
      final isPenarikan = jenis == 'penarikan' || 
                         jenis == 'PENARIKAN SALDO' ||
                         jenis.contains('penarikan');
      
      // Cek status
      bool statusMatch = false;
      if (status.toLowerCase() == 'menunggu' || status.toLowerCase() == 'menunggu konfirmasi') {
        statusMatch = topup.isPending;
      } else if (status.toLowerCase() == 'berhasil') {
        statusMatch = topup.isSuccess;
      } else if (status.toLowerCase() == 'gagal') {
        statusMatch = topup.isFailed;
      }
      
      return isPenarikan && statusMatch;
    }).toList();

    // Convert ke format table data
    return filtered.map((topup) => topupToTableData(topup)).toList();
  }
}