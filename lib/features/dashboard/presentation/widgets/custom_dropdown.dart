import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            // Ajustamos el padding para que se vea centrado
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
          ),
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFE724C)),
        ),
      ),
    );
  }
}