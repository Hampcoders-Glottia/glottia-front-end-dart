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
    return await repository.createPromotion(params.venueId, params.promotion);
  }
}

class CreatePromotionParams extends Equatable {
  final int venueId;
  final Promotion promotion;

  const CreatePromotionParams({required this.venueId, required this.promotion});

  @override
  List<Object?> get props => [venueId, promotion];
}