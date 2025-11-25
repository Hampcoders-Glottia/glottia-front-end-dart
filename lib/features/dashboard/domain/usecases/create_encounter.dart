import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/encounter_creation_params.dart';
import '../repositories/encounter_repository.dart';

class CreateEncounter implements UseCase<bool, EncounterCreationParams> {
  final EncounterRepository repository;

  CreateEncounter(this.repository);

  @override
  Future<Either<Failure, bool>> call(EncounterCreationParams params) async {
    // Aquí podrías agregar validaciones de negocio puras antes de llamar al repo
    // Ej: Validar que la fecha no sea en el pasado (aunque la UI lo limite)
    if (params.scheduledAt.isBefore(DateTime.now())) {
      return const Left(ValidationFailure("La fecha no puede ser en el pasado"));
    }
    
    return await repository.createEncounter(params);
  }
}