import 'package:dartz/dartz.dart';
import 'package:mobile_frontend/core/error/exceptions.dart';
import 'package:mobile_frontend/core/network/token_storage.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final TokenStorage tokenStorage;
  // (Aquí también inyectarías un NetworkInfo para chequear conexión)

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final authResponse = await authRemoteDataSource.login(username, password);
      
      await tokenStorage.saveToken(authResponse.token);

      try {
        final profileModel = await profileRemoteDataSource.getProfileByEmail(
          authResponse.username, 
          authResponse.token);
          return Right(profileModel); 
      } catch (e) {
        print('Error fetching profile: $e');
        return Right(User(
          id: authResponse.id.toString(),
          username: authResponse.username,
          name: 'User', // Placeholder
        ));
      }
  } on ServerException catch (e) {
      return Left(ServerFailure());
  } catch (e) {
    return Left(ServerFailure());
  }
  }

  @override
  Future<Either<Failure, User>> register(
      String nombre, String apellido, String username, String password, String userType) async {
    try {
      // 1. Crear usuario en IAM (Auth)
      await authRemoteDataSource.register(username, password);

      // 2. Mapear el tipo de usuario del Front ('learner'/'owner') al del Back ('LEARNER'/'PARTNER')
      final businessRole = userType == 'owner' ? 'PARTNER' : 'LEARNER';

      // 3. Preparar datos para Profile
      final profileData = ProfileModel.registerToJson(
        firstName: nombre,
        lastName: apellido,
        username: username,
        businessRole: businessRole, // Enviamos el rol dinámico
      );

      // 4. Crear perfil
      final profileModel = await profileRemoteDataSource.createProfile(profileData);
      
      return Right(profileModel);

    } catch (e) {
      //TODO: Si falla aqui, tienes un usuario creado sin perfil.
      // Deberías manejar la limpieza o el rollback.
      return Left(ServerFailure());
    }
  }
// ...

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Implement logout logic here (clear tokens, etc.)
      await tokenStorage.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}