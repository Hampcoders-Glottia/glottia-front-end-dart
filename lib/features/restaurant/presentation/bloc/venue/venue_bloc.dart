import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/features/restaurant/data/datasources/venue_remote_data_source.dart';

// --- Eventos ---
abstract class VenueEvent {}
class LoadPartnerVenues extends VenueEvent {
  final int partnerId;
  LoadPartnerVenues(this.partnerId);
}
class CreateVenuePressed extends VenueEvent {
  final int partnerId;
  final String name;
  final String address;
  final String city;
  final int venueTypeId; // Ej: 1 = Coworking

  CreateVenuePressed({
    required this.partnerId,
    required this.name,
    required this.address,
    required this.city,
    required this.venueTypeId,
  });
}

// --- Estados ---
abstract class VenueState {}
class VenueInitial extends VenueState {}
class VenueLoading extends VenueState {}
class VenueLoaded extends VenueState {
  final List<dynamic> venues;
  VenueLoaded(this.venues);
}
class VenueCreatedSuccess extends VenueState {}
class VenueError extends VenueState {
  final String message;
  VenueError(this.message);
}

// --- BLoC ---
class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRemoteDataSource dataSource;

  VenueBloc({required this.dataSource}) : super(VenueInitial()) {
    
    on<LoadPartnerVenues>((event, emit) async {
      emit(VenueLoading());
      try {
        final venues = await dataSource.getPartnerVenues(event.partnerId);
        emit(VenueLoaded(venues));
      } catch (e) {
        emit(VenueError("Error cargando locales"));
      }
    });

    on<CreateVenuePressed>((event, emit) async {
      emit(VenueLoading());
      try {
        // 1. Crear el Venue
        final venueId = await dataSource.createVenue({
          "name": event.name,
          "street": event.address,
          "city": event.city,
          "state": event.city, // Simplificación
          "postalCode": "00000",
          "country": "Peru",
          "venueTypeId": event.venueTypeId 
        });

        // 2. Asociarlo al Partner
        await dataSource.addVenueToPartnerRegistry(event.partnerId, venueId);

        emit(VenueCreatedSuccess());
        // Recargar la lista
        add(LoadPartnerVenues(event.partnerId));
      } catch (e) {
        emit(VenueError("No se pudo crear el local: $e"));
      }
    });
  }
}