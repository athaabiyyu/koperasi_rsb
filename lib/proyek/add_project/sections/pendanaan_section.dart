import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';

class PendanaanSection extends StatelessWidget {
  final int? initialNominal;

  const PendanaanSection({super.key, this.initialNominal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          label: 'Nominal yang dibutuhkan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
          initialValue: initialNominal?.toString(),
        ),
        const SizedBox(height: 18),
        const CustomTextFormField(
          label: 'Aset Jaminan',
          hint: 'Contoh: Mobil, Motor, dll',
          validator: _required,
        ),
        const SizedBox(height: 18),
        const CustomTextFormField(
          label: 'Nilai Aset Jaminan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
