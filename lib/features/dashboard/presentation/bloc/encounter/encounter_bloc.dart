import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_frontend/features/dashboard/domain/repositories/encounter_repository.dart';
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
  final EncounterRepository repository;

  EncounterBloc({required this.createEncounter, required this.searchEncounters, required this.getUpcomingEncounters, required this.repository,}) : super(EncounterInitial()) {
    // Handle to create
    on<CreateEncounterPressed>(_onCreateEncounter);

    // Handle to search
    on<SearchEncountersRequested>(_onSearchEncounters);

    // Handle to load my reservations
    on<LoadMyReservations>(_onLoadMyReservations);
    on<LoadEncountersByLearnerRequested>(_onLoadEncountersByLearner); // NUEVO

  }

  Future<void> _onSearchEncounters(
    SearchEncountersRequested event,
    Emitter<EncounterState> emit,
  ) async {
    emit(EncounterLoading());

    final result = await searchEncounters(SearchEncountersParams(
      date: event.date,
      location: event.location,
      languageId: event.languageId,
      cefrLevelId: event.cefrLevelId,
      page: event.page,
      size: event.size,
      topic: event.topic, // agregar topic
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
    print('Evento _onCreateEncounter recibido con topic: ${event.topic}'); // Agregar aquí
    emit(EncounterLoading());

    // 1. Combinar Fecha y Hora en un solo DateTime
    final scheduledAtLocal = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.time.hour,
      event.time.minute,
    );

    final scheduledAt = scheduledAtLocal.toUtc();
    print('scheduledAt local: $scheduledAtLocal, UTC: $scheduledAt');

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
    print('Resultado del caso de uso: $result'); // Agregar aquí

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

  Future<void> _onLoadEncountersByLearner(
      LoadEncountersByLearnerRequested event,
      Emitter<EncounterState> emit,
      ) async {
    emit(EncounterLoading());

    final result = await repository.getEncountersByLearnerId(event.learnerId);

    result.fold(
          (failure) => emit(const EncounterFailure("Error al cargar encuentros")),
          (encounters) => emit(EncounterSearchSuccess(encounters)),
    );
  }
}