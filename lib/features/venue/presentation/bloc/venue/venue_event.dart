part of 'venue_bloc.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar la lista
class LoadPartnerVenues extends VenueEvent {
  final int partnerId;
  const LoadPartnerVenues(this.partnerId);
  
  @override
  List<Object> get props => [partnerId];
}

// Evento para crear un local
class CreateVenuePressed extends VenueEvent {
  final String name;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final int venueTypeId;
  final int partnerId; 

  const CreateVenuePressed({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.venueTypeId,
    required this.partnerId,
  });

  @override
  List<Object> get props => [name, street, city, partnerId];
}

class LoadAllVenues extends VenueEvent {}