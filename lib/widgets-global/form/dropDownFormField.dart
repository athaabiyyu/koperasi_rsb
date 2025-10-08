import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String? value;

  const CustomDropdownFormField({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.validator,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update selected value jika widget.value berubah
    if (oldWidget.value != widget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
    
    // CRITICAL FIX: Reset jika selected value tidak ada di items list
    if (_selectedValue != null && !widget.items.contains(_selectedValue)) {
      setState(() {
        _selectedValue = null;
      });
    }
    
    // CRITICAL FIX: Reset jika items list berubah (misalnya jadi kosong)
    if (oldWidget.items != widget.items && widget.items.isEmpty) {
      setState(() {
        _selectedValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRequired = widget.validator != null;
    
    // CRITICAL FIX: Validasi final sebelum render
    // Pastikan _selectedValue ada di items, jika tidak set null
    final String? validValue = (_selectedValue != null && widget.items.contains(_selectedValue))
        ? _selectedValue
        : null;

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
          value: validValue, // Gunakan validValue bukan _selectedValue
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: strokeGray, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
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
          ),
          validator: widget.validator,
          items: widget.items.isEmpty
              ? null // Return null jika items kosong untuk avoid error
              : widget.items
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
          onChanged: widget.onChanged == null
              ? null // Disable dropdown jika onChanged null
              : (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  widget.onChanged!(value);
                },
        ),
      ],
    );
  }
}