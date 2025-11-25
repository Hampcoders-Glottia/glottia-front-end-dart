import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/encounter_creation_params.dart';

abstract class EncounterRepository {
  /// Crea un nuevo encuentro/reserva en el backend.
  /// Retorna [true] si fue exitoso, o un [Failure] si falló.
  Future<Either<Failure, bool>> createEncounter(EncounterCreationParams params);
}