import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final String nombre;

  const RegistrationSuccessScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    // Auto-navegar al Login después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        // ⚠️ CAMBIO CRÍTICO: 
        // Usamos pushNamedAndRemoveUntil para borrar el historial de navegación
        // y evitar que el usuario vuelva a la pantalla de éxito con el botón "Atrás".
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              'Registrado',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: kPrimaryBlue,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: kPrimaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Correctamente',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: kPrimaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                // ⚠️ TEXTO ACTUALIZADO
                'Redirigiendo al inicio de sesión...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}