import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import 'package:mobile_frontend/core/network/token_storage.dart';
import '../../../../core/error/exceptions.dart'; 
import '../models/auth_response_model.dart';
import '../models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<void> register(String username, String password);
  Future<ProfileModel> getProfileByUserId(int userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl({required this.dio, required this.tokenStorage});

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    const endpoint = '$baseUrl/authentication/sign-in';
    try {
      final response = await dio.post(
        endpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      // Dio throws an exeption for non-2xx responses, so we handle success here
      final authResponse = AuthResponseModel.fromJson(response.data);

      // Store the token securely
      await tokenStorage.saveToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException(
            'Failed to login: ${e.response?.statusCode} ${e.response?.statusMessage}');
      } else {
        throw ServerException('Failed to login: ${e.message}');
      }
    }
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      await dio.post(
        '$baseUrl/authentication/sign-up',
        data: {
          'username': username,
          'password': password,
        },
      );

      // If registration is successful, do nothing (or handle as needed)
      return;
    } on DioException catch (e) {
      throw ServerException('Failed to register: ${e.message}');
    }
  }

  @override
  Future<ProfileModel> getProfileByUserId(int userId) async {
    // Según backend: ProfilesController -> GET /api/v1/profiles/user/{userId}
    final endpoint = '$baseUrl/profiles/user/$userId'; 
    
    try {
      // El token ya debe estar en los headers gracias al AuthInterceptor que vi en tus archivos
      final response = await dio.get(endpoint);
      
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw ServerException('Perfil no encontrado');
      }
    } on DioException catch (e) {
      throw ServerException('Error al obtener perfil: ${e.message}');
    }
  }
}