import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class PendanaanSection extends StatelessWidget {
  const PendanaanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              label: 'Nominal yang dibutuhkan',
              hint: 'Rp',
              keyboardType: TextInputType.number,
              validator: _required,
              initialValue: provider.formData['nominal']?.toString(),
              onChanged: (value) => provider.updateFormData('nominal', value),
            ),
            const SizedBox(height: 18),
            CustomTextFormField(
              label: 'Aset Jaminan',
              hint: 'Contoh: Mobil, Motor, dll',
              validator: _required,
              initialValue: provider.formData['asset_jaminan'],
              onChanged: (value) => provider.updateFormData('asset_jaminan', value),
            ),
            const SizedBox(height: 18),
            CustomTextFormField(
              label: 'Nilai Aset Jaminan',
              hint: 'Rp',
              keyboardType: TextInputType.number,
              validator: _required,
              initialValue: provider.formData['nilai_jaminan']?.toString(),
              onChanged: (value) => provider.updateFormData('nilai_jaminan', value),
            ),
          ],
        );
      },
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;