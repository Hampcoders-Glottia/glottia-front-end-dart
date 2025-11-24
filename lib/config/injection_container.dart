import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/const/backend_urls.dart';
import 'package:mobile_frontend/core/network/auth_interceptor.dart';
import 'package:mobile_frontend/core/network/token_storage.dart';

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
    () => AuthRemoteDataSourceImpl(dio: sl(), tokenStorage: sl()),
  );

  // Register Token Storage
  sl.registerLazySingleton(() => TokenStorage());
  // Register Interceptor with Token Storage
  sl.registerLazySingleton(() => AuthInterceptor(tokenStorage: sl()));
  // Register Dio with Interceptor
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: Headers.jsonContentType,
    ));
  
    dio.interceptors.add(sl<AuthInterceptor>());
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  });

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