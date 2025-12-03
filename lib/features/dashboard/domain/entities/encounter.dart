import 'package:equatable/equatable.dart';

class Encounter extends Equatable {
  final int id;
  final String topic;
  final String language;
  final String level;
  final DateTime scheduledAt;
  final String venueName;    //Nuevo campo
  final String venueAddress; // Nuevo campo
  final int currentParticipants; // Opcional, si lo usas
  final int maxCapacity;

  const Encounter({
    required this.id,
    required this.topic,
    required this.language,
    required this.level,
    required this.scheduledAt,
    required this.venueName,
    required this.venueAddress,
    this.currentParticipants = 0,
    required this.maxCapacity,
  });

  @override
  List<Object?> get props => [id, topic, language, venueName, scheduledAt];
}