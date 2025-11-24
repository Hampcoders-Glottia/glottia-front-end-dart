import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/loyalty_stats.dart';
import '../entities/encounter.dart';

abstract class DashboardRepository {
  Future<Either<Failure, LoyaltyStats>> getLearnerStats();
  Future<Either<Failure, List<Encounter>>> getUpcomingEncounters();
}