import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reservation_params.dart';
import '../repositories/reservation_repository.dart';

class CreateReservation implements UseCase<bool, ReservationParams> {
  final ReservationRepository repository;

  CreateReservation(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReservationParams params) async {

    return await repository.createReservation(params.venueId, params);
  }
}