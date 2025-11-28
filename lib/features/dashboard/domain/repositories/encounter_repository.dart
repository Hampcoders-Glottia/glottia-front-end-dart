import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/encounter.dart';
import '../entities/encounter_creation_params.dart';

abstract class EncounterRepository {
  Future<Either<Failure, bool>> createEncounter(EncounterCreationParams params);
  Future<Either<Failure, List<Encounter>>> searchEncounters({
    String? date,
    String? location,
    int? languageId,
    int? cefrLevelId,
    int page = 0,
    int size = 10,
  });
}