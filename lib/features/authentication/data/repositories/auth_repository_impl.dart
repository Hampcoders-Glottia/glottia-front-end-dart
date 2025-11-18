import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  // 1. Inyecta las dos fuentes de datos
  final AuthRemoteDataSource authRemoteDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  // (Aquí también inyectarías un NetworkInfo para chequear conexión)

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.profileRemoteDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // (Aquí chequearías la conexión a internet)
    try {
      // 1. Llama a la API de Auth para obtener el token
      final authResponse = await authRemoteDataSource.login(email, password);

      // 2. Llama a la API de Profiles para obtener los datos del usuario
      final profileModel = await profileRemoteDataSource.getProfileByEmail(
        email,
        authResponse.token,
      );
      
      // 3. Devuelve la entidad User (que es ProfileModel)
      return Right(profileModel);
      
    } catch (e) {
      // (Aquí deberías manejar ServerException, CacheException, etc.)
      return Left(ServerFailure()); 
    }
  }

  @override
  Future<Either<Failure, User>> register(
      String nombre, String apellido, String email, String password) async {
    try {
      // 1. Llama a la API de Auth para crear el usuario (IAM)
      // (Tu backend ignora nombre y apellido aquí, solo usa email y pass)
      await authRemoteDataSource.register(email, password);

      // 2. Prepara los datos del perfil
      final profileData = ProfileModel.registerToJson(
        firstName: nombre,
        lastName: apellido,
        email: email,
      );

      // 3. Llama a la API de Profiles para crear el perfil
      final profileModel = await profileRemoteDataSource.createProfile(profileData);
      
      // 4. Devuelve la entidad User (que es ProfileModel)
      return Right(profileModel);

    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Implement logout logic here (clear tokens, etc.)
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}