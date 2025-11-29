part of 'promotion_bloc.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();
  @override
  List<Object> get props => [];
}

class PromotionInitial extends PromotionState {}
class PromotionLoading extends PromotionState {}

class PromotionLoaded extends PromotionState {
  final List<Promotion> promotions;
  const PromotionLoaded(this.promotions);
}

class PromotionCreatedSuccess extends PromotionState {} // Para navegar atrás tras crear

class PromotionError extends PromotionState {
  final String message;
  const PromotionError(this.message);
}