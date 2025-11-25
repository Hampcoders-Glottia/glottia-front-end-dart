import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_learner_stats.dart';
import '../../../domain/usecases/get_upcoming_encounters.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetLearnerStats getLearnerStats;
  final GetUpcomingEncounters getUpcomingEncounters;

  DashboardBloc({
    required this.getLearnerStats,
    required this.getUpcomingEncounters,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // Ejecutamos ambas peticiones en paralelo para optimizar tiempo
    final results = await Future.wait([
      getLearnerStats(NoParams()),
      getUpcomingEncounters(NoParams()),
    ]);

    // Resultados individuales (son de tipo Either)
    final statsResult = results[0]; 
    final encountersResult = results[1];

    // Verificamos el resultado de las Estadísticas
    statsResult.fold(
      (failure) {
        // Si falla, emitimos error
        emit(const DashboardError(message: "No se pudieron cargar las estadísticas."));
      },
      (stats) {
        // Si las estadísticas cargaron bien, verificamos los Encuentros
        encountersResult.fold(
          (failure) {
            // Si fallan los encuentros, emitimos error
            emit(const DashboardError(message: "No se pudieron cargar los encuentros."));
          },
          (encounters) {
            // ¡ÉXITO TOTAL! Ambos cargaron correctamente
            // Casteamos explícitamente para que Dart no se queje
            emit(DashboardLoaded(
              stats: stats as dynamic, 
              reservations: encounters as dynamic,
            ));
          },
        );
      },
    );
  }
}