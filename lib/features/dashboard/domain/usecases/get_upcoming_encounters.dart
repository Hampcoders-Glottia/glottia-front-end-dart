import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/encounter.dart';
import '../repositories/dashboard_repository.dart';

class GetUpcomingEncounters implements UseCase<List<Encounter>, NoParams> {
  final DashboardRepository repository;

  GetUpcomingEncounters(this.repository);

  @override
  Future<Either<Failure, List<Encounter>>> call(NoParams params) async {
    return await repository.getUpcomingEncounters();
  }
}