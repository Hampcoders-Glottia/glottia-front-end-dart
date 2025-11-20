// features/authentication/widgets/language_option_card.dart
import 'package:flutter/material.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/authentication/data/models/language.dart';

class LanguageOptionCard extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionCard({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBlue.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimaryBlue : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: kPrimaryBlue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          child: Row(
            children: [
              // Bandera
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  language.flagEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              
              // Nombre del idioma
              Expanded(
                child: Text(
                  language.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? kPrimaryBlue : Colors.black87,
                  ),
                ),
              ),

              // Icono de Check
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: kPrimaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              else
                Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}