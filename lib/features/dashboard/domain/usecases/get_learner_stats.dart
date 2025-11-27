import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/loyalty_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetLearnerStats implements UseCase<LoyaltyStats, int> {
  final DashboardRepository repository;

  GetLearnerStats(this.repository);

  @override
  Future<Either<Failure, LoyaltyStats>> call(int learnerId) async {
    return await repository.getLearnerStats();
  }
}