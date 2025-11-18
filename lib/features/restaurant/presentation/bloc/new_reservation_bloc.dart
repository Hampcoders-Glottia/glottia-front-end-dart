// lib/features/restaurant/presentation/bloc/new_reservation_bloc.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_reservation.dart';
import '../../domain/entities/reservation_params.dart';
import '../../../../core/error/failures.dart';

part 'new_reservation_event.dart';
part 'new_reservation_state.dart';

class NewReservationBloc
    extends Bloc<NewReservationEvent, NewReservationState> {
  
  final CreateReservation createReservation;

  NewReservationBloc({
    required this.createReservation,
  }) : super(const NewReservationState()) {
    
    on<NameChanged>(_onNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<EmailChanged>(_onEmailChanged);
    on<GuestCountChanged>(_onGuestCountChanged);
    on<DateChanged>(_onDateChanged);
    on<TimeChanged>(_onTimeChanged);
    on<TablePreferenceChanged>(_onTablePreferenceChanged);
    on<OccasionChanged>(_onOccasionChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onEmailChanged(EmailChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onGuestCountChanged(
      GuestCountChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(guestCount: event.guestCount));
  }

  void _onDateChanged(DateChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onTimeChanged(TimeChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(time: event.time));
  }

  void _onTablePreferenceChanged(
      TablePreferenceChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(tablePreference: event.tablePreference));
  }

  void _onOccasionChanged(
      OccasionChanged event, Emitter<NewReservationState> emit) {
    emit(state.copyWith(occasion: event.occasion));
  }

  Future<void> _onFormSubmitted(
      FormSubmitted event, Emitter<NewReservationState> emit) async {
    
    emit(state.copyWith(status: FormStatus.loading));

    final params = ReservationParams(
      name: state.name,
      phone: state.phone,
      email: state.email,
      guestCount: state.guestCount,
      date: state.date,
      time: state.time,
    );

    final result = await createReservation(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: FormStatus.failure,
          errorMessage: failure is ValidationFailure 
              ? failure.message 
              : 'Error inesperado del servidor.',
        ));
      },
      (success) {
        emit(state.copyWith(status: FormStatus.success));
      },
    );
  }
}