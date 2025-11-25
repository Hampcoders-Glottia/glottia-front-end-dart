// lib/features/authentication/domain/usecases/register_user.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// 1. El Caso de Uso
class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // 2. Simplemente delega la llamada al repositorio
    return await repository.register(
      params.nombre,
      params.apellido,
      params.email,
      params.password,
      params.userType,
    );
  }
}

// 3. Los Parámetros que necesita este caso de uso
class RegisterParams extends Equatable {
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String userType; // Nuevo campo para el tipo de usuario
  final String? street;
  final String? number;
  final String? city;
  final String? postalCode;
  final String? country;

  const RegisterParams({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    required this.userType,
    this.street,
    this.number,
    this.city,
    this.postalCode,
    this.country,
  });

  @override
  List<Object?> get props => [nombre, apellido, email, password, userType, street, number, city, postalCode, country];
}