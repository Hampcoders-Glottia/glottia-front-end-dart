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
  // --- Controladores de Texto ---
  // Datos Básicos
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Datos de Dirección (Nuevos)
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  // Controllers for Partner fields 
  final _businessNameController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _rucController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Estado del formulario
  final _formKey = GlobalKey<FormState>();
  String _selectedUserType = 'learner'; // 'learner' o 'owner'

  @override
  void dispose() {
    // Limpieza de controladores al cerrar la pantalla
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _businessNameController.dispose();
    _legalNameController.dispose();
    _rucController.dispose();
    _contactPhoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Ocultar teclado antes de procesar
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // Disparamos el evento con la lógica condicional
      context.read<AuthBloc>().add(
            RegisterRequested(
              nombre: _nameController.text,
              apellido: _lastNameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              userType: _selectedUserType,
              // Solo enviamos datos de dirección si es un Aprendiz
              street: _selectedUserType == 'learner' ? _streetController.text : null,
              number: _selectedUserType == 'learner' ? _numberController.text : null,
              city: _selectedUserType == 'learner' ? _cityController.text : null,
              postalCode: _selectedUserType == 'learner' ? _zipController.text : null,
              country: _selectedUserType == 'learner' ? _countryController.text : null,
              // Solo enviamos datos de partner si es un Dueño de Local
              businessName: _selectedUserType == 'owner' ? _businessNameController.text : null,
              legalName: _selectedUserType == 'owner' ? _legalNameController.text : null,
              taxId: _selectedUserType == 'owner' ? _rucController.text : null,
              contactPhone: _selectedUserType == 'owner' ? _contactPhoneController.text : null,
              description: _selectedUserType == 'owner' ? _descriptionController.text : null,
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
            if (state is AuthRegistered) {
              // Navegación exitosa
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
                    // Título
                    Text(
                      'Regístrate',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: kPrimaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Completa tus datos para comenzar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // --- SELECTOR DE TIPO DE USUARIO ---
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

                    // --- CAMPOS DE DATOS BÁSICOS ---
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

                    PasswordField(
                      controller: _passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Requerido';
                        if (val.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),

                    // --- SECCIÓN DIRECCIÓN (Expandible) ---
                    // Se muestra solo si es Aprendiz
                    AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          const Text("Datos del Negocio", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryBlue, fontSize: 16)),
                          const SizedBox(height: 15),

                          AuthField(
                             controller: _businessNameController, 
                             hintText: 'Nombre Comercial', 
                             prefixIcon: Icons.store,
                             validator: (v) => _selectedUserType == 'owner' && (v == null || v.isEmpty) ? 'Requerido' : null
                           ),
                          const SizedBox(height: 15),

                          AuthField(
                             controller: _legalNameController, 
                             hintText: 'Razón Social', 
                             prefixIcon: Icons.business,
                             validator: (v) => _selectedUserType == 'owner' && (v == null || v.isEmpty) ? 'Requerido' : null
                           ),
                           const SizedBox(height: 15),

                           Row(
                            children: [
                              Expanded(
                                child:  
                                AuthField(
                                  controller: _rucController, 
                                  hintText: 'RUC / Tax ID',
                                  prefixIcon: Icons.badge_outlined,
                                  validator: (v) => _selectedUserType == 'owner' && (v == null || v.isEmpty) ? 'Requerido' : null
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child:  
                                AuthField(
                                  controller: _contactPhoneController, 
                                  hintText: 'Teléfono de Contacto',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: (v) => _selectedUserType == 'owner' && (v == null || v.isEmpty) ? 'Requerido' : null
                                ),
                              ),
                            ],
                           ),
                            const SizedBox(height: 15),
                            AuthField(
                              controller: _descriptionController, 
                              hintText: 'Descripción del Negocio', 
                              prefixIcon: Icons.description_outlined,
                              validator: (v) => _selectedUserType == 'owner' && (v == null || v.isEmpty) ? 'Requerido' : null
                            ),
                        ],
                      ),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Dirección de Contacto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryBlue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          // Calle (Full Width)
                          AuthField(
                            controller: _streetController,
                            hintText: 'Calle / Avenida',
                            prefixIcon: Icons.add_road,
                            validator: (val) => _selectedUserType == 'learner' && (val == null || val.isEmpty) ? 'Requerido' : null,
                          ),
                          const SizedBox(height: 15),

                          // Número y Código Postal (Misma fila)
                          Row(
                            children: [
                              Expanded(
                                child: AuthField(
                                  controller: _numberController,
                                  hintText: 'Número',
                                  prefixIcon: Icons.tag,
                                  validator: (val) => _selectedUserType == 'learner' && (val == null || val.isEmpty) ? 'Req.' : null,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: AuthField(
                                  controller: _zipController,
                                  hintText: 'Cod. Postal',
                                  prefixIcon: Icons.markunread_mailbox_outlined,
                                  validator: (val) => _selectedUserType == 'learner' && (val == null || val.isEmpty) ? 'Req.' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Ciudad (Full Width)
                          AuthField(
                            controller: _cityController,
                            hintText: 'Ciudad',
                            prefixIcon: Icons.location_city,
                            validator: (val) => _selectedUserType == 'learner' && (val == null || val.isEmpty) ? 'Requerido' : null,
                          ),
                          const SizedBox(height: 15),

                          // País (Full Width)
                          AuthField(
                            controller: _countryController,
                            hintText: 'País',
                            prefixIcon: Icons.public,
                            validator: (val) => _selectedUserType == 'learner' && (val == null || val.isEmpty) ? 'Requerido' : null,
                          ),
                        ],
                      ),
                      crossFadeState: _selectedUserType == 'learner' 
                          ? CrossFadeState.showSecond 
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                    // -------------------------------------

                    const SizedBox(height: 30),

                    // Botón de Registro
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

                    // Footer
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

  // Widget auxiliar para las opciones de tipo de usuario
  Widget _buildUserTypeOption(String label, String value) {
    final isSelected = _selectedUserType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Ocultamos el teclado al cambiar de opción para mejorar la UX
          FocusScope.of(context).unfocus();
          setState(() => _selectedUserType = value);
        },
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