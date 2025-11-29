import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promotion.dart';
import '../repositories/promotion_repository.dart';

class CreatePromotion implements UseCase<bool, CreatePromotionParams> {
  final PromotionRepository repository;

  CreatePromotion(this.repository);

  @override
  Future<Either<Failure, bool>> call(CreatePromotionParams params) async {
    return await repository.createPromotion(params.venueId, params.promotion, params.partnerId);
  }
}

class CreatePromotionParams extends Equatable {
  final int venueId;
  final Promotion promotion;
  final int partnerId;

  const CreatePromotionParams({required this.venueId, required this.promotion, required this.partnerId});

  @override
  List<Object?> get props => [venueId, promotion, partnerId];
}