import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';

class PendanaanSection extends StatelessWidget {
  final int? initialNominal;
  final TextEditingController? nominalController;
  final TextEditingController? asetJaminanController;
  final TextEditingController? nilaiAsetController;

  const PendanaanSection({
    super.key,
    this.initialNominal,
    this.nominalController,
    this.asetJaminanController,
    this.nilaiAsetController,
  });

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
          initialValue: nominalController == null ? initialNominal?.toString() : null,
          controller: nominalController,
        ),
        const SizedBox(height: 18),
        CustomTextFormField(
          label: 'Aset Jaminan',
          hint: 'Contoh: Mobil, Motor, dll',
          validator: _required,
          controller: asetJaminanController,
        ),
        const SizedBox(height: 18),
        CustomTextFormField(
          label: 'Nilai Aset Jaminan',
          hint: 'Rp',
          keyboardType: TextInputType.number,
          validator: _required,
          controller: nilaiAsetController,
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
