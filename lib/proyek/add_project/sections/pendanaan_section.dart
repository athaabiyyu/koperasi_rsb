import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';

class PendanaanSection extends StatelessWidget {
  const PendanaanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CustomTextFormField(
          label: 'Nominal yang dibutuhkan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
        ),
        SizedBox(height: 18),
        CustomTextFormField(
          label: 'Aset Jaminan',
          hint: 'Contoh: Mobil, Motor, dll',
          validator: _required,
        ),
        SizedBox(height: 18),
        CustomTextFormField(
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
