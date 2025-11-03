class InvestorSummary {
  final String nama;
  final String tokenCreatedAt;
  final int jumlahToken;
  final int totalNilaiToken;

  InvestorSummary({
    required this.nama,
    required this.tokenCreatedAt,
    required this.jumlahToken,
    required this.totalNilaiToken,
  });

  factory InvestorSummary.fromJson(Map<String, dynamic> json) {
    return InvestorSummary(
      nama: json['nama'] ?? '-',
      tokenCreatedAt: json['token_created_at'] ?? '',
      jumlahToken: json['jumlah_token'] ?? 0,
      totalNilaiToken: json['total_nilai_token'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'token_created_at': tokenCreatedAt,
      'jumlah_token': jumlahToken,
      'total_nilai_token': totalNilaiToken,
    };
  }

  // Format date to readable format
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(tokenCreatedAt);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      
      // Convert to WIB (GMT+7)
      final wibDate = dateTime.toUtc().add(const Duration(hours: 7));
      
      return '${wibDate.day} ${months[wibDate.month - 1]} ${wibDate.year} ${wibDate.hour.toString().padLeft(2, '0')}:${wibDate.minute.toString().padLeft(2, '0')} WIB';
    } catch (e) {
      return '-';
    }
  }

  // Format rupiah
  String get formattedAmount {
    final s = totalNilaiToken.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  // Get initials for avatar
  String get initials {
    if (nama.isEmpty || nama == '-') return '?';
    
    final parts = nama.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
  }

  // Generate avatar color based on name
  int get avatarColorIndex {
    int hash = 0;
    for (int i = 0; i < nama.length; i++) {
      hash = nama.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return hash.abs() % 10; // Return index 0-9
  }
}