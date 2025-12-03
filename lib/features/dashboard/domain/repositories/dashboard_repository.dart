import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/loyalty_stats.dart';
import '../entities/encounter.dart';
import '../entities/loyalty_transaction.dart';

abstract class DashboardRepository {
  Future<Either<Failure, LoyaltyStats>> getLearnerStats();
  Future<Either<Failure, List<Encounter>>> getUpcomingEncounters(int learnerId);
  Future<Either<Failure, List<Encounter>>> getEncounterHistory(int learnerId);
  Future<Either<Failure, List<LoyaltyTransaction>>> getPointsHistory(int learnerId, {int page = 0, int size = 10});
}