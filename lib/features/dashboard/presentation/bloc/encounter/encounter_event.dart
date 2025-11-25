part of 'encounter_bloc.dart';

abstract class EncounterEvent extends Equatable {
  const EncounterEvent();
  @override
  List<Object> get props => [];
}

class CreateEncounterPressed extends EncounterEvent {
  final DateTime date;
  final TimeOfDay time;
  final String topic;
  final String language;
  final String level;
  final int venueId; // Por ahora será 1, pero lo recibimos por si acaso

  const CreateEncounterPressed({
    required this.date,
    required this.time,
    required this.topic,
    required this.language,
    required this.level,
    required this.venueId,
  });
}