import 'package:equatable/equatable.dart';
import '../../../domain/entities/encounter.dart';
import '../../../domain/entities/loyalty_stats.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final LoyaltyStats stats;
  final List<Encounter> reservations; // Próximas
  final List<Encounter> history;      // Nuevo: Historial

  const DashboardLoaded({
    required this.stats,
    required this.reservations,
    this.history = const [], // Por defecto vacía
  });

  @override
  List<Object> get props => [stats, reservations, history];
  
  // Útil para actualizar parcialmente
  DashboardLoaded copyWith({
    LoyaltyStats? stats,
    List<Encounter>? reservations,
    List<Encounter>? history,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      reservations: reservations ?? this.reservations,
      history: history ?? this.history,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object> get props => [message];
}