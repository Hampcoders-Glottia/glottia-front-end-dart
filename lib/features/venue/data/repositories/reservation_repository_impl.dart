import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reservation_params.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_remote_data_source.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;
  // (Aquí también inyectarías un NetworkInfo)

  ReservationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> createReservation(
      int venueId, ReservationParams params) async {
    
    // (Aquí chequearías la conexión a internet)
    
    try {
      // 1. Validar que la fecha no sea nula
      if (params.date == null) {
        return Left(ValidationFailure('Por favor selecciona una fecha.'));
      }

      // 2. PASO A: Buscar mesas disponibles
      final availableTables = await remoteDataSource.getAvailableTables(
        venueId,
        params.date!,
        params.guestCount,
      );

      // 3. Verificar si hay mesas
      if (availableTables.isEmpty) {
        return Left(ValidationFailure('No hay mesas disponibles para esa fecha y cantidad de personas.'));
      }

      // 4. Seleccionar la primera mesa disponible
      final tableToBook = availableTables.first;

      // 5. PASO B: Reservar la mesa
      final success = await remoteDataSource.reserveTable(
        tableToBook.id,
        params.date!,
      );

      return Right(success);

    } catch (e) {
      return Left(ServerFailure());
    }
  }
}