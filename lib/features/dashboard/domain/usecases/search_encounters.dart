import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/encounter.dart';
import '../repositories/encounter_repository.dart';

class SearchEncounters implements UseCase<List<Encounter>, SearchEncountersParams> {
  final EncounterRepository repository;

  SearchEncounters(this.repository);

  @override
  Future<Either<Failure, List<Encounter>>> call(SearchEncountersParams params) async {
    return await repository.searchEncounters(
      date: params.date,
      location: params.location,
      languageId: params.languageId,
      cefrLevelId: params.cefrLevelId,
      topic: params.topic,
      page: params.page,
      size: params.size,
    );
  }
}

class SearchEncountersParams {
  final String? date;
  final String? location;
  final int? languageId;
  final int? cefrLevelId;
  final String? topic; // NUEVO
  final int page;
  final int size;

  SearchEncountersParams({
    this.date,
    this.location,
    this.languageId,
    this.cefrLevelId,
    this.topic,
    this.page = 0,
    this.size = 10,
  });
}