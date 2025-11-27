import 'package:equatable/equatable.dart';
import '../../../domain/entities/encounter.dart';
import '../../../domain/entities/loyalty_stats.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final LoyaltyStats stats;
  final List<Encounter> reservations;

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