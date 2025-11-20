import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos un ValueNotifier para manejar la visibilidad de la contraseña internamente
    final obscureText = ValueNotifier<bool>(isPassword);

    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return TextFormField(
          controller: controller,
          obscureText: value,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      value ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => obscureText.value = !obscureText.value,
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF4A6FA5), width: 1.5),
            ),
          ),
        );
      },
    );
  }
}