import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_field.dart'; // Usamos el widget genérico que creamos antes

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar el texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Para validar el formulario

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Disparamos el evento al BLoC
      context.read<AuthBloc>().add(
            LoginRequested(email: email, password: password),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ajustes de diseño según tu Figma
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlue),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Back', 
          style: TextStyle(color: kPrimaryBlue, fontSize: 16),
        ),
        titleSpacing: -10, // Acerca el texto "Back" a la flecha
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }

            if (state is AuthSuccess) {
              // 🚀 LÓGICA DE REDIRECCIÓN AUTOMÁTICA
              // El estado AuthSuccess ya tiene el 'user'.
              // Verificamos el tipo y navegamos.
              
              /* TODO: Descomenta esto cuando tu User tenga el campo 'type'
               if (state.user.type == 'owner') {
                 Navigator.of(context).pushReplacementNamed('/owner_home');
               } else {
                 Navigator.of(context).pushReplacementNamed('/learner_home');
               }
              */
              
              // Por ahora, vamos al home genérico
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Título
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: kPrimaryBlue, // #4A6FA5 según tu diseño
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    
                    // Subtítulo
                    const Text(
                      'Ingrese su correo y su contraseña para\niniciar sesión',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // --- CAMPOS (Usando AuthField reutilizable) ---
                    AuthField(
                      controller: _emailController,
                      hintText: 'Correo',
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El correo es requerido';
                        if (!value.contains('@')) return 'Correo inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    AuthField(
                      controller: _passwordController,
                      hintText: 'Contraseña',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true, // Activa el ojito
                      validator: (value) {
                        if (value == null || value.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),

                    // --- Olvidaste contraseña ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navegar a recuperación
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Olvidaste tu contraseña? ',
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                            children: [
                              TextSpan(
                                text: 'Recuperala aquí',
                                style: TextStyle(
                                  color: kPrimaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- Botón Login ---
                    ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kPrimaryBlue,
                        elevation: 2,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white, 
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Continuar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),

                    // --- Footer Registro ---
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'No tienes una cuenta? ',
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Registrate',
                              style: const TextStyle(
                                color: kPrimaryBlue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacementNamed('/register');
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}