import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Authentication imports
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/usecases/login_user.dart';
import '../features/authentication/domain/usecases/register_user.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/data/datasources/profile_remote_data_source.dart';

// Dashboard imports 
import '../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/domain/usecases/get_learner_stats.dart';
import '../features/dashboard/domain/usecases/get_upcoming_encounters.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication
  
  // BLoC Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
    ),
  );

  // Casos de Uso Auth
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Repositorio Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
    ),
  );

  // Data Sources Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  //! Features - Dashboard

  // BLoC Dashboard - Ahora inyectamos los casos de uso reales
  sl.registerFactory(
    () => DashboardBloc(
      getLearnerStats: sl(),
      getUpcomingEncounters: sl(),
    ), 
  );

  // Casos de Uso Dashboard
  sl.registerLazySingleton(() => GetLearnerStats(sl()));
  sl.registerLazySingleton(() => GetUpcomingEncounters(sl()));

  // Repositorio Dashboard
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  // sl.registerLazySingleton<NetworkInfo>(
  //  () => NetworkInfoImpl(sl()),
  // );

  //! External
  sl.registerLazySingleton(() => http.Client());
}