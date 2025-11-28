import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final int learnerId; // ID real del usuario

  const LoadDashboardData(this.learnerId);

  @override
  List<Object> get props => [learnerId];
}