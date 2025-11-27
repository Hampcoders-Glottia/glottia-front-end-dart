part of 'venue_bloc.dart';

abstract class VenueState extends Equatable {
  const VenueState();
  
  @override
  List<Object> get props => [];
}

// Estado inicial antes de que pase nada
class VenueInitial extends VenueState {}

// Estado cuando se está cargando información (spinner)
class VenueLoading extends VenueState {}

// Estado cuando la lista de locales se cargó exitosamente
class VenueLoaded extends VenueState {
  final List<dynamic> venues; // Idealmente cambiar dynamic por VenueModel

  const VenueLoaded(this.venues);

  @override
  List<Object> get props => [venues];
}

// Estado de éxito específico para operaciones de escritura (Crear/Editar)
// Útil para mostrar Snackbars o cerrar pantallas sin recargar toda la lista si no quieres
class VenueOperationSuccess extends VenueState {
  final String message;

  const VenueOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Estado de error
class VenueError extends VenueState {
  final String message;

  const VenueError(this.message);

  @override
  List<Object> get props => [message];
}