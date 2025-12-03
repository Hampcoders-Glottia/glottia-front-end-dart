import '../../domain/entities/loyalty_transaction.dart';

class LoyaltyTransactionModel extends LoyaltyTransaction {
  const LoyaltyTransactionModel({
    required super.id,
    required super.type,
    required super.points,
    required super.description,
    super.encounterId,
    super.venueId,
    super.venueName,
    required super.createdAt,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransactionModel(
      id: json['id'] as int,
      type: _parseTransactionType(json['type'] as String),
      points: json['points'] as int,
      description: json['description'] as String,
      encounterId: json['encounterId'] as int?,
      venueId: json['venueId'] as int?,
      venueName: json['venueName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static TransactionType _parseTransactionType(String type) {
    switch (type.toUpperCase()) {
      case 'CREATION':
        return TransactionType.creation;
      case 'ATTENDANCE':
        return TransactionType.attendance;
      case 'WELCOME_BONUS':
        return TransactionType.welcomeBonus;
      case 'NO_SHOW':
        return TransactionType.noShow;
      case 'LATE_CANCEL':
        return TransactionType.lateCancel;
      default:
        return TransactionType.creation;
    }
  }
}

