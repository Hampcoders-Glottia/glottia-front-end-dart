import 'package:equatable/equatable.dart';

abstract class LoyaltyEvent extends Equatable {
  const LoyaltyEvent();

  @override
  List<Object?> get props => [];
}

class LoadPointsHistory extends LoyaltyEvent {
  final int learnerId;
  final int page;
  final int size;

  const LoadPointsHistory({
    required this.learnerId,
    this.page = 0,
    this.size = 20,
  });

  @override
  List<Object?> get props => [learnerId, page, size];
}

