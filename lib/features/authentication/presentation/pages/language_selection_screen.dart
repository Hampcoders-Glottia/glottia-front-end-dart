import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/authentication/data/models/language.dart';
import 'package:mobile_frontend/features/authentication/presentation/widgets/languague_option_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguageCode;

  void _onLanguageSelected(String code) {
    setState(() {
      selectedLanguageCode = code;
    });
  }

  void _onContinue() {
    if (selectedLanguageCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un idioma'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Aquí podrías disparar un evento para guardar el idioma en el backend
    // context.read<ProfileBloc>().add(UpdateLanguage(selectedLanguageCode!));

    // == CAMBIO CRÍTICO ==
    // Usamos la ruta '/home' porque en main.dart es donde se inyecta el DashboardBloc.
    // Si usas MaterialPageRoute directo, el Dashboard fallará.
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botón de retroceso
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: kPrimaryBlue),
                  label: const Text('Atrás', style: TextStyle(color: kPrimaryBlue)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                '¿Qué te gustaría\naprender?',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: kPrimaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 32, 
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              Text(
                'Selecciona un idioma para empezar',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Lista de idiomas
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(), 
                  itemCount: availableLanguages.length,
                  itemBuilder: (context, index) {
                    final language = availableLanguages[index];
                    final isSelected = selectedLanguageCode == language.code;

                    return LanguageOptionCard(
                      language: language,
                      isSelected: isSelected,
                      onTap: () => _onLanguageSelected(language.code),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Botón continuar
              ElevatedButton(
                onPressed: selectedLanguageCode == null ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: kPrimaryBlue,
                  disabledBackgroundColor: kPrimaryBlue.withOpacity(0.3),
                  elevation: selectedLanguageCode == null ? 0 : 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selectedLanguageCode == null ? Colors.white70 : Colors.white,
                      ),
                    ),
                    if (selectedLanguageCode != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}