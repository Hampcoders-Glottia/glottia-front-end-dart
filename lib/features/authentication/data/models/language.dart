import 'package:flutter/material.dart';

class Language {
  final String code;
  final String name;
  final String flagEmoji;
  final Color? flagColor;

  const Language({
    required this.code,
    required this.name,
    required this.flagEmoji,
    this.flagColor,
  });
}

// Lista de idiomas disponibles
final List<Language> availableLanguages = [
  const Language(
    code: 'en',
    name: 'INGLES',
    flagEmoji: '🇬🇧',
    flagColor: null,
  ),
  const Language(
    code: 'es',
    name: 'ESPAÑOL',
    flagEmoji: '🇪🇸',
    flagColor: null,
  ),
  const Language(
    code: 'zh',
    name: 'CHINO',
    flagEmoji: '🇨🇳',
    flagColor: null,
  ),
  const Language(
    code: 'fr',
    name: 'FRANCES',
    flagEmoji: '🇫🇷',
    flagColor: null,
  ),
  const Language(
    code: 'ru',
    name: 'RUSO',
    flagEmoji: '🇷🇺',
    flagColor: null,
  ),
];