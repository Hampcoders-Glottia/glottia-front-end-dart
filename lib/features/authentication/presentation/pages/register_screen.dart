import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:mobile_frontend/features/authentication/presentation/pages/registration_success_screen.dart';
import 'package:mobile_frontend/features/authentication/presentation/widgets/password_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

import '../widgets/auth_field.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Estado local para el tipo de usuario (Por defecto 'learner')
  String _selectedUserType = 'learner'; 

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Disparamos el evento con TODOS los datos, incluido el tipo de usuario
      context.read<AuthBloc>().add(
            RegisterButtonPressed(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              name: _nameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              userType: _selectedUserType, // <--- Dato clave
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlue),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
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
            // Asumo que tu estado de éxito se llama AuthSuccess o AuthRegistered
            if (state is AuthSuccess) { 
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => RegistrationSuccessScreen(nombre: _nameController.text),
                ),
              );
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
                    Text(
                      'Registrate',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: kPrimaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Regístrate a la aplicación para poder\nutilizar todas sus funcionalidades!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // --- SELECTOR DE TIPO DE USUARIO ---
                    // Este bloque crea los dos botones: Aprendiz / Dueño Local
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          _buildUserTypeOption('Aprendiz', 'learner'),
                          _buildUserTypeOption('Dueño Local', 'owner'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    // -----------------------------------

                    AuthField(
                      controller: _nameController,
                      hintText: 'Nombre',
                      prefixIcon: Icons.person_outline,
                      validator: (val) => val!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),

                    AuthField(
                      controller: _lastNameController,
                      hintText: 'Apellido',
                      prefixIcon: Icons.person_outline,
                      validator: (val) => val!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),

                    AuthField(
                      controller: _emailController,
                      hintText: 'Correo',
                      prefixIcon: Icons.email_outlined,
                      validator: (val) => !val!.contains('@') ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 15),

                    PasswordField(controller: _passwordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'La contraseña es requerida';
                      if (val.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    }),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kPrimaryBlue,
                        disabledBackgroundColor: kPrimaryBlue.withOpacity(0.6),
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
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),
                    
                    // Footer: Ir a Login
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Ya tienes una cuenta? ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Inicia Sesión aquí',
                              style: const TextStyle(
                                color: kPrimaryBlue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacementNamed('/login');
                                },
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'O continúa con una cuenta',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(icon: Icons.apple, onTap: () {}),
                        const SizedBox(width: 20),
                        _SocialButton(icon: Icons.facebook, onTap: () {}),
                        const SizedBox(width: 20),
                        _SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget auxiliar para construir las opciones del toggle
  Widget _buildUserTypeOption(String label, String value) {
    final isSelected = _selectedUserType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedUserType = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? kPrimaryBlue : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}