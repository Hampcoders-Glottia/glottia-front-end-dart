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
  final int creatorId; // ID del usuario que crea el encuentro

  const CreateEncounterPressed({
    required this.date,
    required this.time,
    required this.topic,
    required this.language,
    required this.level,
    required this.venueId,
    required this.creatorId,
  });

}

// Modificado: evento de búsqueda con más filtros y paginación
class SearchEncountersRequested extends EncounterEvent {
  final String? date;
  final int? languageId;
  final int? cefrLevelId;
  final String? topic;
  final String? location;
  final int page;
  final int size;

  const SearchEncountersRequested({
    this.date,
    this.languageId,
    this.cefrLevelId,
    this.topic,
    this.location,
    this.page = 0,
    this.size = 10,
  });

  @override
  List<Object> get props => [date ?? '', languageId ?? 0, cefrLevelId ?? 0, topic ?? '', location ?? '', page, size];
}

class LoadMyReservations extends EncounterEvent {
  final int learnerId;
  const LoadMyReservations(this.learnerId);
  @override
  List<Object> get props => [learnerId];
}

class LoadEncountersByLearnerRequested extends EncounterEvent {
  final int learnerId;
  const LoadEncountersByLearnerRequested(this.learnerId);
  @override
  List<Object> get props => [learnerId];
}