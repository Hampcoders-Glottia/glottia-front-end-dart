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

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // 1. Login básico (IAM)
      final authResponse = await authRemoteDataSource.login(email, password);
      
      // 2. Guardar token
      await tokenStorage.saveToken(authResponse.token);

      // 3. Hidratar Perfil (Obtener datos de negocio: Learner/Partner IDs)
      try {
        // Usa el token recién obtenido para cargar el perfil
        final profileModel = await profileRemoteDataSource.getProfileByEmail(authResponse.username, authResponse.token);
        
        return Right(profileModel);
      } catch (e) {
        // Si falla la carga del perfil, devolvemos un usuario básico para no bloquear el login
        // (Aunque esto podría causar problemas de navegación si faltan IDs)
        return Right(User(
          id: authResponse.id,
          username: authResponse.username,
          name: 'User',
          email: authResponse.username,
          firstName: 'User',
          lastName: '',
          userType: 'UNKNOWN',
        ));
      }
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register(String nombre, String apellido, String email, String password, String userType) async {
    try {
      // 1. Crear usuario en IAM (Auth) - El backend espera username/password
      await authRemoteDataSource.register(email, password);

      // 2. Mapear el tipo de usuario del Front ('learner'/'owner') al del Back ('LEARNER'/'PARTNER')
      final businessRole = userType == 'owner' ? 'PARTNER' : 'LEARNER';

      // 3. Preparar datos para crear el Profile completo
      final profileData = ProfileModel.registerToJson(
        firstName: nombre,
        lastName: apellido,
        username: email,
        password: password, // Requerido por CreateCompleteProfileCommand del backend
        businessRole: businessRole,
      );

      // 4. Crear perfil en el backend
      final profileModel = await profileRemoteDataSource.createProfile(profileData);
      
      return Right(profileModel);

    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenStorage.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}