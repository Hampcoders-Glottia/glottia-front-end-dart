import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../../../core/error/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LanguageSelected>(_onLanguageSelected);
    on<LogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUser(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is ServerFailure) {
          emit(const AuthFailure('Error del servidor al iniciar sesión.'));
        } else {
          emit(const AuthFailure('Error inesperado'));
        }
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }

  FutureOr<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await registerUser(
      RegisterParams(
        nombre: event.nombre,
        apellido: event.apellido,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is ServerFailure) {
          emit(const AuthFailure('Error del servidor al registrar. Inténtalo de nuevo.'));
        } else {
          emit(const AuthFailure('Error inesperado'));
        }
      },
      (user) {
        emit(AuthRegistered(user: user));
      },
    );
  }

  FutureOr<void> _onLanguageSelected(
      LanguageSelected event, Emitter<AuthState> emit) {
    emit(AuthLanguageSelected(language: event.language));
  }

  FutureOr<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}