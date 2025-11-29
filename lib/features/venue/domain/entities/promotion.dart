import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double discountPercentage;
  final int promotionTypeId; // 1: Descuento, 2: 2x1, etc (Según backend seeders)

  const Promotion({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.discountPercentage,
    required this.promotionTypeId,
  });

  @override
  List<Object?> get props => [id, name, description, startDate, endDate, discountPercentage, promotionTypeId];
}