import '../../domain/entities/encounter.dart';

class EncounterModel extends Encounter {
  const EncounterModel({
    required super.id,
    required super.topic,
    required super.language,
    required super.level,
    required super.scheduledAt,
    required super.venueName,
    required super.venueAddress,
    super.currentParticipants,
    required super.maxCapacity,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    return EncounterModel(
      id: json['id'],
      topic: json['topic'] ?? 'Sin tema',
      language: json['language'] ?? 'N/A',
      level: json['level'] ?? 'N/A',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      // Mapeo de los nuevos campos del backend
      venueName: json['venueName'] ?? 'Ubicación desconocida',
      venueAddress: json['venueAddress'] ?? '',
      currentParticipants: (json['attendances'] as List?)?.length ?? 0,
      maxCapacity: json['maxCapacity'] ?? 4,
    );
  }
}