import 'package:flutter/material.dart';

class PembagianHasilSection extends StatelessWidget {
  const PembagianHasilSection({super.key});

  @override
  Widget build(BuildContext context) {
    const bullets = [
      'Pengusul Proyek akan menerima 10% dari hasil keseluruhan. Bagian ini diperuntukkan bagi mereka yang bertanggung jawab dalam pengembangan dan implementasi proyek.',
      'Tim admin berhak atas 20% dari hasil. Ini mencakup tim manajemen yang mengelola operasi dan memastikan keberlangsungan proyek.',
      'Koperasi akan mendapatkan 20% dari hasil. Bagian ini akan didistribusikan kepada anggota koperasi, baik yang berstatus anggota biasa maupun anggota platinum, dalam bentuk Sisa Hasil Usaha (SHU).',
      'Penyertaan modal kerja akan memperoleh 50% dari hasil sebagai imbalan atas kontribusi modal mereka dalam proyek.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (final text in bullets) ...[
          _BulletItem(text: text),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  ', style: TextStyle(fontSize: 18, height: 1.4)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
