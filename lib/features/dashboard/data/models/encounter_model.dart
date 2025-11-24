import '../../domain/entities/encounter.dart';

class EncounterModel extends Encounter {
  const EncounterModel({
    required super.id,
    required super.topic,
    required super.language,
    required super.scheduledAt,
    required super.venueName,
    required super.status,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    return EncounterModel(
      id: json['id'],
      topic: json['topic'],
      language: json['language'],
      // El backend devuelve un array o string para la fecha, Dart parsea ISO-8601
      scheduledAt: DateTime.parse(json['scheduledAt']),
      // OJO: Tu EncounterResource devuelve venueId, no el nombre del venue.
      // Por ahora pondremos un placeholder hasta que hagamos el fetch del Venue.
      venueName: 'Venue #${json['venueId']}', 
      status: json['status'],
    );
  }
}