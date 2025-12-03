import '../../domain/entities/loyalty_stats.dart';

class LoyaltyStatsModel extends LoyaltyStats {
  const LoyaltyStatsModel({
    required super.points,
    required super.encountersAttended,
    // Agrega otros campos si es necesario
  });

  factory LoyaltyStatsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyStatsModel(
      points: json['points'] as int,
      encountersAttended: json['encountersAttended'] as int,
      // Mapea otros campos
    );
  }
}