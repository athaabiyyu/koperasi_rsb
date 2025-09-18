import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
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
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: strokeGray,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: strokeGray,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: strokeGray,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: grayFont,
                width: 2.0,
              ),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: grayFont,
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
