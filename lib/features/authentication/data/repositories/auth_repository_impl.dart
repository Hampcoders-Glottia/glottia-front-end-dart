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
      final authResponse = await authRemoteDataSource.login(email, password);

      final profileModel = await profileRemoteDataSource.getProfileByEmail(
        authResponse.username, 
        authResponse.token
        );
    
      return Right(profileModel);

    } catch (e, stackTrace) {
      print("Error en: $e");
      // (Aquí deberías manejar ServerException, CacheException, etc.)
      print(stackTrace);
      return Left(ServerFailure()); 
    }
  }

  @override
  Future<Either<Failure, User>> register(
      String nombre, String apellido, String email, String password, String userType) async {
    try {
      // 1. Crear usuario en IAM (Auth)
      await authRemoteDataSource.register(email, password);

      // 2. Mapear el tipo de usuario del Front ('learner'/'owner') al del Back ('LEARNER'/'PARTNER')
      final businessRole = userType == 'owner' ? 'PARTNER' : 'LEARNER';

      // 3. Preparar datos para Profile
      final profileData = ProfileModel.registerToJson(
        firstName: nombre,
        lastName: apellido,
        email: email,
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
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}