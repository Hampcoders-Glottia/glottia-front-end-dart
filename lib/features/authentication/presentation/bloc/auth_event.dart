import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String nombre;
  final String apellido;
  final String email;
  final String password;

  const RegisterRequested({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [nombre, apellido, email, password];
}

class LanguageSelected extends AuthEvent {
  final String language;

  const LanguageSelected({required this.language});

  @override
  List<Object?> get props => [language];
}

class LogoutRequested extends AuthEvent {}
