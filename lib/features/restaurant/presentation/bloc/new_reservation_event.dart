part of 'new_reservation_bloc.dart';

abstract class NewReservationEvent extends Equatable {
  const NewReservationEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends NewReservationEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class PhoneChanged extends NewReservationEvent {
  final String phone;

  const PhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class EmailChanged extends NewReservationEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class GuestCountChanged extends NewReservationEvent {
  final int guestCount;

  const GuestCountChanged(this.guestCount);

  @override
  List<Object?> get props => [guestCount];
}

class DateChanged extends NewReservationEvent {
  final DateTime? date;

  const DateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class TimeChanged extends NewReservationEvent {
  final TimeOfDay? time;

  const TimeChanged(this.time);

  @override
  List<Object?> get props => [time];
}

class TablePreferenceChanged extends NewReservationEvent {
  final String? tablePreference;

  const TablePreferenceChanged(this.tablePreference);

  @override
  List<Object?> get props => [tablePreference];
}

class OccasionChanged extends NewReservationEvent {
  final String? occasion;

  const OccasionChanged(this.occasion);

  @override
  List<Object?> get props => [occasion];
}

class FormSubmitted extends NewReservationEvent {
  const FormSubmitted();
}
