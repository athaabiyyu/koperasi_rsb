import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? initialValue;
  // Optional: when true and keyboardType is number, format with thousands separator (e.g., 1.000.000)
  final bool formatRupiah;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final void Function(String)? onChanged; // ADDED: onChanged callback
  final void Function(String?)? onSaved;   // ADDED: onSaved callback

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.initialValue,
    this.formatRupiah = false,
    this.controller,
    this.inputFormatters,
    this.enabled = true,
    this.onChanged, // ADDED
    this.onSaved,   // ADDED
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRequired = widget.validator != null;
    final bool isNumberOnly = widget.keyboardType == TextInputType.number;
    final List<TextInputFormatter>? inputFormatters = isNumberOnly
        ? <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            if (widget.formatRupiah) ThousandsSeparatorInputFormatter(),
          ]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: " *",
                      style: GoogleFonts.poppins(
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
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          validator: widget.validator,
          maxLines: widget.maxLines,
          initialValue: widget.initialValue,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters ?? inputFormatters,
          onChanged: widget.onChanged,  // ADDED
          onSaved: widget.onSaved,      // ADDED
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.poppins(color: strokeGray, fontSize: 14),
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.maxLines > 1 ? 16 : 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: strokeGray, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: strokeGray, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: grayFont, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: strokeGray.withOpacity(0.5), width: 1.0),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: grayFont,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('.', '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    final formatted = _formatWithDots(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithDots(String digits) {
    final buffer = StringBuffer();
    int count = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      buffer.write(digits[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join();
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?)? validator;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "No. Handphone *",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: enabled,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Nomor wajib diisi";
            }
            if (!value.startsWith("62") && !value.startsWith("8")) {
              return "Nomor tidak valid";
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                "+62",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            hintText: "812-3456-7890",
            hintStyle: GoogleFonts.poppins(color: strokeGray, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: strokeGray, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: strokeGray, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: grayFont, width: 1.5),
            ),
          ),
          onChanged: (value) {
            // Kalau user ketik "62" di depan, hapus supaya tidak dobel
            if (value.startsWith("62")) {
              controller.text = value.substring(2);
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
        ),
      ],
    );
  }
}