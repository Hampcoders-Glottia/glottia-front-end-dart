import 'package:equatable/equatable.dart';

enum TransactionType {
  creation,
  attendance,
  welcomeBonus,
  noShow,
  lateCancel,
}

class LoyaltyTransaction extends Equatable {
  final int id;
  final TransactionType type;
  final int points;
  final String description;
  final int? encounterId;
  final int? venueId;
  final String? venueName;
  final DateTime createdAt;

  const LoyaltyTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    this.encounterId,
    this.venueId,
    this.venueName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        points,
        description,
        encounterId,
        venueId,
        venueName,
        createdAt,
      ];
}

