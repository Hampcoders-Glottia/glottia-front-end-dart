import 'package:equatable/equatable.dart';
import '../../domain/entities/loyalty_stats.dart'; // Nueva entidad
import '../../domain/entities/encounter.dart';     // Nueva entidad

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final LoyaltyStats stats;          // Tipo actualizado
  final List<Encounter> reservations; // Tipo actualizado

  const DashboardLoaded({
    required this.stats,
    required this.reservations,
  });

  @override
  List<Object?> get props => [stats, reservations];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}