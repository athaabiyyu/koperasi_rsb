import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class PembagianHasilSection extends StatelessWidget {
  const PembagianHasilSection({super.key});

  String? _validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Masukkan angka yang valid';
    }
    if (number < 0 || number > 100) {
      return 'Persentase harus antara 0-100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Info Text
            Text(
              'Pembagian Hasil (sudah dalam %)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),

            // Pelaksana Proyek Field
            _buildPercentageField(
              context: context,
              provider: provider,
              label: 'Pelaksana Proyek',
              placeholder: 'Cth. 20',
              fieldKey: 'bagian_pelaksana',
            ),
            const SizedBox(height: 16),

            // Koperasi Field
            _buildPercentageField(
              context: context,
              provider: provider,
              label: 'Koperasi',
              placeholder: 'Cth. 30',
              fieldKey: 'bagian_koperasi',
            ),
            const SizedBox(height: 16),

            // Pemilik Proyek Field
            _buildPercentageField(
              context: context,
              provider: provider,
              label: 'Pemilik Proyek',
              placeholder: 'Cth. 10',
              fieldKey: 'bagian_pemilik',
            ),
            const SizedBox(height: 16),

            // Pemodal Proyek Field
            _buildPercentageField(
              context: context,
              provider: provider,
              label: 'Pemodal Proyek',
              placeholder: 'Cth. 40',
              fieldKey: 'bagian_pendana',
            ),
            
            const SizedBox(height: 24),
            
            // Total percentage display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.validatePercentages() 
                    ? Colors.green 
                    : Colors.orange,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Persentase:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${provider.getPercentageTotal()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: provider.validatePercentages() 
                        ? Colors.green 
                        : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            
            if (!provider.validatePercentages())
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Total harus 100%',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPercentageField({
    required BuildContext context,
    required ProjectProvider provider,
    required String label,
    required String placeholder,
    required String fieldKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.formData[fieldKey]?.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: _validatePercentage,
          onChanged: (value) => provider.updateFormData(fieldKey, value),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

String? _required(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;