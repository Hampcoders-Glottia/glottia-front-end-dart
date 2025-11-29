part of 'promotion_bloc.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();
  @override
  List<Object> get props => [];
}

class LoadVenuePromotions extends PromotionEvent {
  final int venueId;
  const LoadVenuePromotions(this.venueId);
}

class CreatePromotionSubmitted extends PromotionEvent {
  final int venueId;
  final String name;
  final String description;
  final double discount;
  final DateTime startDate;
  final DateTime endDate;

  const CreatePromotionSubmitted({
    required this.venueId,
    required this.name,
    required this.description,
    required this.discount,
    required this.startDate,
    required this.endDate,
  });
}