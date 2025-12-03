import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_points_history.dart';
import 'loyalty_event.dart';
import 'loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  final GetPointsHistory getPointsHistory;

  LoyaltyBloc({required this.getPointsHistory}) : super(LoyaltyInitial()) {
    on<LoadPointsHistory>(_onLoadPointsHistory);
  }

  Future<void> _onLoadPointsHistory(
      LoadPointsHistory event,
      Emitter<LoyaltyState> emit,
      ) async {
    print('Cargando historial de puntos para learnerId: ${event.learnerId}, página: ${event.page}, tamaño: ${event.size}');
    emit(LoyaltyLoading());

    final result = await getPointsHistory(
      GetPointsHistoryParams(
        learnerId: event.learnerId,
        page: event.page,
        size: event.size,
      ),
    );

    result.fold(
          (failure) {
        print('Error en el use case: $failure');
        emit(const LoyaltyError('Error cargando historial de puntos'));
      },
          (transactions) {
        print('Transacciones cargadas exitosamente: ${transactions.length}');
        emit(LoyaltyLoaded(transactions: transactions));
      },
    );
  }
}

