import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/encounter.dart';
import '../../domain/entities/encounter_creation_params.dart';
import '../../domain/repositories/encounter_repository.dart';
import '../datasources/encounter_remote_data_source.dart';

class EncounterRepositoryImpl implements EncounterRepository {
  final EncounterRemoteDataSource remoteDataSource;

  EncounterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> createEncounter(EncounterCreationParams params) async {
    try {
      final result = await remoteDataSource.createEncounter(params);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Encounter>>> searchEncounters({
    String? date,
    String? location,
    int? languageId,
    int? cefrLevelId,
    String? topic,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // Llama al data source
      final models = await remoteDataSource.searchEncounters(
        date: date,
        location: location,
        languageId: languageId,
        cefrLevelId: cefrLevelId,
        topic: topic,
        page: page,
        size: size,
      );
      // Retorna éxito (Right)
      return Right(models);
    } catch (e) {
      // Retorna fallo (Left)
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Encounter>>> getEncountersByLearnerId(int learnerId) async {
    try {
      final models = await remoteDataSource.getEncountersByLearnerId(learnerId);
      return Right(models);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}