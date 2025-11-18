part of 'new_reservation_bloc.dart';

enum FormStatus { initial, loading, success, failure }

class NewReservationState extends Equatable {
  final String name;
  final String phone;
  final String email;
  final int guestCount;
  final DateTime? date;
  final TimeOfDay? time;
  final String? tablePreference;
  final String? occasion;
  final FormStatus status;
  final String? errorMessage;

  const NewReservationState({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.guestCount = 2,
    this.date,
    this.time,
    this.tablePreference,
    this.occasion,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  NewReservationState copyWith({
    String? name,
    String? phone,
    String? email,
    int? guestCount,
    DateTime? date,
    TimeOfDay? time,
    String? tablePreference,
    String? occasion,
    FormStatus? status,
    String? errorMessage,
  }) {
    return NewReservationState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      guestCount: guestCount ?? this.guestCount,
      date: date ?? this.date,
      time: time ?? this.time,
      tablePreference: tablePreference ?? this.tablePreference,
      occasion: occasion ?? this.occasion,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
        guestCount,
        date,
        time,
        tablePreference,
        occasion,
        status,
        errorMessage,
      ];
}
