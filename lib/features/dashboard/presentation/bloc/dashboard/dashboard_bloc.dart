import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // Ejecutamos las 3 llamadas en paralelo para mayor velocidad
    final results = await Future.wait([
      repository.getLearnerStats(),
      repository.getUpcomingEncounters(event.learnerId),
      repository.getEncounterHistory(event.learnerId), // Llamada nueva
    ]);

    final statsResult = results[0] as dynamic; // Cast necesario por Future.wait genérico
    final upcomingResult = results[1] as dynamic;
    final historyResult = results[2] as dynamic;

    // Lógica simple: Si falla stats o upcoming, mostramos error. 
    // Si falla historial, podríamos mostrar lista vacía (opcional).
    statsResult.fold(
      (failure) => emit(const DashboardError("Error cargando estadísticas")),
      (stats) {
        upcomingResult.fold(
          (failure) => emit(const DashboardError("Error cargando reservas")),
          (upcoming) {
             historyResult.fold(
               (failure) => emit(DashboardLoaded(
                 stats: stats, 
                 reservations: upcoming,
                 history: const [] // Fallback seguro para historial
               )), 
               (history) => emit(DashboardLoaded(
                 stats: stats, 
                 reservations: upcoming,
                 history: history // ✅ Datos reales
               )),
             );
          },
        );
      },
    );
  }
}