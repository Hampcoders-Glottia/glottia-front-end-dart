import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReservationParams extends Equatable {
  final int venueId;
  final String name;
  final String phone;
  final String email;
  final int guestCount;
  final DateTime? date;
  final TimeOfDay? time;
  // (Omitimos 'tablePreference' y 'occasion' por ahora,
  // ya que el backend no los soporta, pero podrían añadirse)

  const ReservationParams({
    required this.venueId,
    required this.name,
    required this.phone,
    required this.email,
    required this.guestCount,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [venueId, name, phone, email, guestCount, date, time];
}