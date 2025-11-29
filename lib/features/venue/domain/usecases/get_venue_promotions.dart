import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promotion.dart';
import '../repositories/promotion_repository.dart';

class GetVenuePromotions implements UseCase<List<Promotion>, int> {
  final PromotionRepository repository;

  GetVenuePromotions(this.repository);

  @override
  Future<Either<Failure, List<Promotion>>> call(int venueId) async {
    return await repository.getPromotionsByVenue(venueId);
  }
}