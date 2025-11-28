import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_frontend/features/restaurant/data/datasources/venue_remote_data_source.dart'; 

part 'venue_event.dart';
part 'venue_state.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRemoteDataSource venueRemoteDataSource;

  VenueBloc({required this.venueRemoteDataSource}) : super(VenueInitial()) {
    on<LoadPartnerVenues>(_onLoadPartnerVenues);
    on<CreateVenuePressed>(_onCreateVenuePressed);
    on<LoadAllVenues>(_onLoadAllVenues);
  }

  FutureOr<void> _onLoadPartnerVenues(
      LoadPartnerVenues event, Emitter<VenueState> emit) async {
    // 1. Emitir estado de carga
    emit(VenueLoading());
    
    try {
      // 2. Llamar al datasource
      final venues = await venueRemoteDataSource.getPartnerVenues(event.partnerId);
      
      // 3. Emitir éxito con los datos
      emit(VenueLoaded(venues));
    } catch (e) {
      // 4. Manejar errores
      emit(VenueError(e.toString()));
    }
  }

  FutureOr<void> _onCreateVenuePressed(
      CreateVenuePressed event, Emitter<VenueState> emit) async {
    // Guardamos el estado actual por si hay error, para no perder la lista
    // (Opcional, dependiendo de tu UX)
    
    emit(VenueLoading());
    
    try {
      // PASO 1: Crear el Venue físico
      final venueData = {
        "name": event.name,
        "street": event.street,
        "city": event.city,
        "state": event.state,
        "postalCode": event.postalCode,
        "country": event.country,
        "venueTypeId": event.venueTypeId
      };

      // Asumimos que createVenue retorna el ID (int)
      final int newVenueId = await venueRemoteDataSource.createVenue(venueData);

      // PASO 2: Vincularlo al Partner (Usando el ID real)
      await venueRemoteDataSource.addVenueToPartnerRegistry(
          event.partnerId, 
          newVenueId
      );

      // OPCIÓN A: Recargar la lista automáticamente (Recomendado para Dashboards)
      // Esto disparará _onLoadPartnerVenues y actualizará la UI con el nuevo ítem
      add(LoadPartnerVenues(event.partnerId));
      
      // OPCIÓN B: Si prefieres solo notificar éxito y navegar atrás manualmente:
      // emit(const VenueOperationSuccess("Local creado correctamente"));

    } catch (e) {
      emit(VenueError("No se pudo registrar el local: ${e.toString()}"));
      // Si falla, opcionalmente podrías intentar recargar la lista anterior
      // add(LoadPartnerVenues(event.partnerId)); 
    }
  }

  FutureOr<void> _onLoadAllVenues(
    LoadAllVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      final venues = await venueRemoteDataSource.getAllVenues();
      emit(VenueLoaded(venues));
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }
}