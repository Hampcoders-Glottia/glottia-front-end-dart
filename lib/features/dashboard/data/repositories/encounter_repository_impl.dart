import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
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
}