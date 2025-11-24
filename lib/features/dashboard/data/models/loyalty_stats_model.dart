import '../../domain/entities/loyalty_stats.dart';

class LoyaltyStatsModel extends LoyaltyStats {
  const LoyaltyStatsModel({
    required super.points,
    required super.encountersAttended,
  });

  factory LoyaltyStatsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyStatsModel(
      // Asegúrate que estos nombres coincidan con tu LoyaltyAccountResource en Java
      points: json['points'] ?? 0,
      encountersAttended: json['encountersAttended'] ?? 0,
    );
  }
}