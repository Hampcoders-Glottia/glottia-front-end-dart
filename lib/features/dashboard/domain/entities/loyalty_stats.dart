import 'package:equatable/equatable.dart';

class LoyaltyStats extends Equatable {
  final int points;
  final int encountersAttended;
  // El backend devuelve encountersCreated y noShowCount también,
  // puedes agregarlos si los quieres mostrar.

  const LoyaltyStats({
    required this.points,
    required this.encountersAttended,
  });

  @override
  List<Object?> get props => [points, encountersAttended];
}