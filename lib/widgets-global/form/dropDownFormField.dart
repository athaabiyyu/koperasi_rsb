import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const CustomDropdownFormField({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? _selectedValue;

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
        DropdownButtonFormField<String>(
          value: _selectedValue,
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
          ),
          validator: widget.validator,
          items: widget.items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
      ],
    );
  }
}
