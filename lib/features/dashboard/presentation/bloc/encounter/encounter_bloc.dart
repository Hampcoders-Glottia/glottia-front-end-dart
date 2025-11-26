import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/encounter_creation_params.dart';
import '../../../domain/usecases/create_encounter.dart';

part 'encounter_event.dart';
part 'encounter_state.dart';

class EncounterBloc extends Bloc<EncounterEvent, EncounterState> {
  final CreateEncounter createEncounter;

  EncounterBloc({required this.createEncounter}) : super(EncounterInitial()) {
    on<CreateEncounterPressed>(_onCreateEncounter);
  }

  Future<void> _onCreateEncounter(
    CreateEncounterPressed event,
    Emitter<EncounterState> emit,
  ) async {
    emit(EncounterLoading());

    // 1. Combinar Fecha y Hora en un solo DateTime
    final scheduledAt = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.time.hour,
      event.time.minute,
    );

    // 2. Crear los parámetros
    final params = EncounterCreationParams(
      creatorId: event.creatorId,
      venueId: event.venueId,
      scheduledAt: scheduledAt,
      topic: event.topic,
      language: event.language,
      level: event.level,
    );

    // 3. Llamar al Caso de Uso
    final result = await createEncounter(params);

    // 4. Emitir resultado
    result.fold(
      (failure) => emit(const EncounterFailure("Error al crear la reserva")),
      (success) => emit(EncounterSuccess()),
    );
  }
}