import 'package:dio/dio.dart';
import 'package:mobile_frontend/core/network/token_storage.dart';
import '../../../../core/error/exceptions.dart'; 
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl({required this.dio, required this.tokenStorage});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/authentication/sign-in',
        data: {
          'username': email,
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
  Future<void> register(String email, String password) async {
    try {
      await dio.post(
        '/authentication/sign-up',
        data: {
          'username': email,
          'password': password,
        },
      );

      // If registration is successful, do nothing (or handle as needed)
      return;
    } on DioException catch (e) {
      throw ServerException('Failed to register: ${e.message}');
    }
  }
}