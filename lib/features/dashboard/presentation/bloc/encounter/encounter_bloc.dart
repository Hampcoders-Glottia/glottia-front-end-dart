import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_frontend/features/dashboard/domain/usecases/get_upcoming_encounters.dart';
import 'package:mobile_frontend/features/dashboard/domain/usecases/search_encounters.dart';
import '../../../domain/entities/encounter.dart';
import '../../../domain/entities/encounter_creation_params.dart';
import '../../../domain/usecases/create_encounter.dart';

part 'encounter_event.dart';
part 'encounter_state.dart';

class EncounterBloc extends Bloc<EncounterEvent, EncounterState> {
  final CreateEncounter createEncounter;
  final SearchEncounters searchEncounters;
  final GetUpcomingEncounters getUpcomingEncounters;

  EncounterBloc({required this.createEncounter, required this.searchEncounters, required this.getUpcomingEncounters}) : super(EncounterInitial()) {
    // Handle to create
    on<CreateEncounterPressed>(_onCreateEncounter);

    // Handle to search
    on<SearchEncountersRequested>(_onSearchEncounters);

    // Handle to load my reservations
    on<LoadMyReservations>(_onLoadMyReservations);
  }

  Future<void> _onSearchEncounters(
    SearchEncountersRequested event,
    Emitter<EncounterState> emit,
  ) async {
    emit(EncounterLoading());

    final result = await searchEncounters(SearchEncountersParams(
      date: event.date,
      languageId: event.languageId,
      // location: ... (puedes agregar más filtros si quieres)
    ));

    result.fold(
      (failure) => emit(const EncounterFailure("Error al buscar encuentros")),
      (encounters) => emit(EncounterSearchSuccess(encounters)),
    );
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

  Future<void> _onLoadMyReservations(
    LoadMyReservations event,
    Emitter<EncounterState> emit,
  ) async {
    emit(EncounterLoading());
  
    final result = await getUpcomingEncounters(event.learnerId); 
    
    result.fold(
      (failure) => emit(EncounterFailure("Error al cargar mis reservas")),
      (encounters) => emit(MyReservationsLoaded(encounters)),
    );
  }
}