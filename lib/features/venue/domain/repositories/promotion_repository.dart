import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/promotion.dart';

abstract class PromotionRepository {
  Future<Either<Failure, List<Promotion>>> getPromotionsByVenue(int venueId);
  Future<Either<Failure, bool>> createPromotion(int venueId, Promotion promotion);
}