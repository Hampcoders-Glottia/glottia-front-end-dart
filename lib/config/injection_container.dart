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
import '../features/dashboard/domain/usecases/search_encounters.dart';
import '../features/dashboard/presentation/bloc/encounter/encounter_bloc.dart';
import '../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import '../features/dashboard/domain/usecases/get_learner_stats.dart';
import '../features/dashboard/domain/usecases/get_upcoming_encounters.dart';

// Encounter imports
import '../features/dashboard/domain/usecases/create_encounter.dart';
import '../features/dashboard/domain/repositories/encounter_repository.dart';
import '../features/dashboard/data/repositories/encounter_repository_impl.dart';
import '../features/dashboard/data/datasources/encounter_remote_data_source.dart';

// Venue imports
import '../features/restaurant/data/datasources/venue_remote_data_source.dart';
import '../features/restaurant/presentation/bloc/venue/venue_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  sl.registerLazySingleton(() => http.Client());
  
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

  //! Features - Authentication
  
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl(), tokenStorage: sl()),
  );
  
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl()), 
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
      tokenStorage: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
    ),
  );

  //! Features - Dashboard

  // Data Sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetLearnerStats(sl()));
  sl.registerLazySingleton(() => GetUpcomingEncounters(sl()));

  // BLoC
  sl.registerFactory(
    () => DashboardBloc(
      getLearnerStats: sl(),
      getUpcomingEncounters: sl(),
    ), 
  );

  //! Features - Encounters (Reservas)
  
  // Data Source
  sl.registerLazySingleton<EncounterRemoteDataSource>(
    () => EncounterRemoteDataSourceImpl(dio: sl()),
  );

  // Repository 
  sl.registerLazySingleton<EncounterRepository>(
    () => EncounterRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateEncounter(sl()));
  sl.registerLazySingleton(() => SearchEncounters(sl()));

  // BLoC Encounter
  // Usamos registerFactory para que se cree uno nuevo cada vez que entramos a la pantalla
  sl.registerFactory(
    () => EncounterBloc(createEncounter: sl(), searchEncounters: sl()),
  );

  //! Features - Restaurant (Venue)
  
  // Data Source
  sl.registerLazySingleton(() => VenueRemoteDataSource(dio: sl()));
  
  // BLoC Venue
  // Usamos registerFactory para que no guarde estado entre pantallas (Owner vs Selection)
  sl.registerFactory(() => VenueBloc(venueRemoteDataSource: sl()));
}