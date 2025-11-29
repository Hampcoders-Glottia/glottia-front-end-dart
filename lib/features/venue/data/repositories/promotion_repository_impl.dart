import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/repositories/promotion_repository.dart';
import '../datasources/promotion_remote_data_source.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final PromotionRemoteDataSource remoteDataSource;

  PromotionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Promotion>>> getPromotionsByVenue(int venueId) async {
    try {
      final promotions = await remoteDataSource.getPromotionsByVenue(venueId);
      return Right(promotions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createPromotion(int venueId, Promotion promotion, int partnerId) async {
    try {
      final result = await remoteDataSource.createPromotion(venueId, promotion, partnerId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}