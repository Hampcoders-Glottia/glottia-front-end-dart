// lib/config/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/usecases/login_user.dart';
// --- 1. Importa el nuevo caso de uso ---
import '../features/authentication/domain/usecases/register_user.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/data/datasources/profile_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication
  
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      // --- 2. Inyecta el nuevo caso de uso en el BLoC ---
      registerUser: sl(),
    ),
  );

  // Casos de Uso
  sl.registerLazySingleton(() => LoginUser(sl()));
  // --- 3. Registra el nuevo caso de uso como Singleton ---
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Repositorio
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  // ...

  //! External
  sl.registerLazySingleton(() => http.Client());
}