import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/loyalty_transaction.dart';
import '../repositories/dashboard_repository.dart';

class GetPointsHistory implements UseCase<List<LoyaltyTransaction>, GetPointsHistoryParams> {
  final DashboardRepository repository;

  GetPointsHistory(this.repository);

  @override
  Future<Either<Failure, List<LoyaltyTransaction>>> call(GetPointsHistoryParams params) async {
    return await repository.getPointsHistory(
      params.learnerId,
      page: params.page,
      size: params.size,
    );
  }
}

class GetPointsHistoryParams {
  final int learnerId;
  final int page;
  final int size;

  const GetPointsHistoryParams({
    required this.learnerId,
    this.page = 0,
    this.size = 10,
  });
}

