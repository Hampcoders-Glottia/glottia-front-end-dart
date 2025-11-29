import '../../domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  const PromotionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.discountPercentage,
    required super.promotionTypeId,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      promotionTypeId: json['promotionTypeId'] ?? 1, // Default a 1 si nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String().split('T')[0], // Formato YYYY-MM-DD
      'endDate': endDate.toIso8601String().split('T')[0],
      'discountPercentage': discountPercentage,
      'promotionTypeId': promotionTypeId,
    };
  }
}