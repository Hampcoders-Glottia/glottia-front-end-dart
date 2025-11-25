part of 'encounter_bloc.dart';

abstract class EncounterState extends Equatable {
  const EncounterState();
  @override
  List<Object> get props => [];
}

class EncounterInitial extends EncounterState {}
class EncounterLoading extends EncounterState {}
class EncounterSuccess extends EncounterState {}

class EncounterFailure extends EncounterState {
  final String message;
  const EncounterFailure(this.message);
  @override
  List<Object> get props => [message];
}