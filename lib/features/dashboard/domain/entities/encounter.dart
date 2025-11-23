import 'package:equatable/equatable.dart';

class Encounter extends Equatable {
  final int id;
  final String topic;
  final String language; // "ENGLISH", "SPANISH"
  final DateTime scheduledAt;
  final String venueName; // Tendremos que resolver esto luego
  final String status; // "PUBLISHED", "READY", etc.

  const Encounter({
    required this.id,
    required this.topic,
    required this.language,
    required this.scheduledAt,
    required this.venueName,
    required this.status,
  });

  @override
  List<Object?> get props => [id, topic, language, scheduledAt, venueName, status];
}