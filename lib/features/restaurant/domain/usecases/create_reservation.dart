import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reservation_params.dart';
import '../repositories/reservation_repository.dart';

// Este caso de uso implementa la interfaz 'UseCase'
// Devuelve un booleano (Right<bool>) en caso de éxito
// y recibe 'ReservationParams'
class CreateReservation implements UseCase<bool, ReservationParams> {
  final ReservationRepository repository;

  CreateReservation(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReservationParams params) async {
    // TODO: La UI no nos da un venueId. Asumiremos 1 por ahora.
    const int hardcodedVenueId = 1;

    return await repository.createReservation(hardcodedVenueId, params);
  }
}