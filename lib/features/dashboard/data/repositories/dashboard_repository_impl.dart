import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/encounter.dart';
import '../../domain/entities/loyalty_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  // TODO: Inyectar un LocalDataSource para obtener el token guardado
  final String _tempToken = "TU_TOKEN_JWT_TEMPORAL"; // Temporal para pruebas

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoyaltyStats>> getLearnerStats() async {
    try {
      // En producción: final token = await localDataSource.getToken();
      final result = await remoteDataSource.getLoyaltyStats(_tempToken);
      return Right(result);
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Encounter>>> getUpcomingEncounters() async {
    try {
      final result = await remoteDataSource.getUpcomingEncounters(_tempToken);
      return Right(result);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}