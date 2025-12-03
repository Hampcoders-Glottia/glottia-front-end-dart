import 'package:equatable/equatable.dart';
import '../../../domain/entities/loyalty_transaction.dart';

abstract class LoyaltyState extends Equatable {
  const LoyaltyState();

  @override
  List<Object?> get props => [];
}

class LoyaltyInitial extends LoyaltyState {}

class LoyaltyLoading extends LoyaltyState {}

class LoyaltyLoaded extends LoyaltyState {
  final List<LoyaltyTransaction> transactions;

  const LoyaltyLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class LoyaltyError extends LoyaltyState {
  final String message;

  const LoyaltyError(this.message);

  @override
  List<Object?> get props => [message];
}

