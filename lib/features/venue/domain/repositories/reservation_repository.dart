import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reservation_params.dart';

abstract class ReservationRepository {
  Future<Either<Failure, bool>> createReservation(
    // (Añadiremos venueId aquí, aunque lo 'hardcodeemos' por ahora)
    int venueId,
    ReservationParams params,
  );
}