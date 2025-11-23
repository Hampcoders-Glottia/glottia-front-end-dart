import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String userType; 

  const RegisterRequested({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [nombre, apellido, email, password, userType];
}

class LanguageSelected extends AuthEvent {
  final String language;

  const LanguageSelected({required this.language});

  @override
  List<Object?> get props => [language];
}

class LogoutRequested extends AuthEvent {}

class RegisterButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String lastName;
  final String userType; // Nuevo campo

  const RegisterButtonPressed({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password, name, lastName, userType];
}