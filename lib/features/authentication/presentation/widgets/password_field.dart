import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  // Agregamos el validador para que funcione con el Form
  final String? Function(String?)? validator; 

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Contraseña',
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField( // ⚠️ Cambio clave: TextField -> TextFormField
        controller: widget.controller,
        obscureText: _obscure,
        validator: widget.validator, // Conectamos el validador
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          filled: true,
          // Asegúrate de que kInputBackground esté definido en app_colors.dart, 
          // si no, usa Colors.grey[100]
          fillColor: Colors.grey[100], 
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.black54,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          // Agregamos un borde rojo para cuando haya error de validación
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
          ),
        ),
      ),
    );
  }
}