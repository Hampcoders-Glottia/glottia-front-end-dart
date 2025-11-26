import 'package:equatable/equatable.dart';

class EncounterCreationParams extends Equatable {
  final int creatorId;
  final int venueId;
  final DateTime scheduledAt;
  final String topic;
  final String language; // Ej: "ENGLISH"
  final String level;    // Ej: "B1"

  const EncounterCreationParams({
    required this.creatorId,
    required this.venueId,
    required this.scheduledAt,
    required this.topic,
    required this.language,
    required this.level,
  });

  @override
  List<Object?> get props => [creatorId, venueId, scheduledAt, topic, language, level];
}