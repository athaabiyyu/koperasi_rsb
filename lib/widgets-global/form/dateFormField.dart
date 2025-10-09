import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomDateFormField extends StatefulWidget {
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomDateFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Gunakan controller dari parent jika ada, kalau tidak buat baru
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Hanya dispose jika controller dibuat lokal (bukan dari parent)
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // default
      firstDate: DateTime(1900), // batas bawah
      lastDate: DateTime.now(), // maksimal hari ini
    );

    if (pickedDate != null) {
      // Format: DD/MM/YYYY (sesuai dengan yang diharapkan di RegistrationPage2)
      final formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      
      setState(() {
        _controller.text = formattedDate;
      });
      
      // Debug log
      print('Date picked: $formattedDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRequired = widget.validator != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          readOnly: true,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: strokeGray,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: strokeGray,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: strokeGray,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: grayFont,
                width: 1.5,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () => _pickDate(context),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.calendar_today,
                  color: grayFont,
                  size: 20,
                ),
              ),
            ),
          ),
          onTap: () => _pickDate(context),
        ),
      ],
    );
  }
}