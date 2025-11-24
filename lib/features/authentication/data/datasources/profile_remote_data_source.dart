import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfileByEmail(String email, String token);
  Future<ProfileModel> createProfile(Map<String, dynamic> profileData);
  Future<ProfileModel> getProfileById(String id, String token);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfileByEmail(String email, String token) async {
    // Endpoint: /api/v1/profiles/search?email=...
    final endpoint = '$baseUrl/profiles/search';
    
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: {
          'email': email
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw ServerException('Error al buscar el perfil: Código ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Manejo específico para cuando no se encuentra (404)
      if (e.response?.statusCode == 404) {
        throw ServerException('Perfil no encontrado para este correo.');
      }
      throw ServerException('Error de conexión al buscar perfil: ${e.message}');
    }
  }

  @override
  Future<ProfileModel> createProfile(Map<String, dynamic> profileData) async {
    // Endpoint: /api/v1/profiles
    // Este endpoint es público según tu WebSecurityConfiguration (permitAll)
    final endpoint = '$baseUrl/profiles';

    try {
      final response = await dio.post(
        endpoint,
        data: profileData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw ServerException('Error al crear el perfil: Código ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException('Fallo al crear perfil: ${e.message}');
    }
  }

  @override
  Future<ProfileModel> getProfileById(String id, String token) async {
    // Endpoint: /api/v1/profiles/{id}
    // CORRECCIÓN CRÍTICA: La ruta es directa, NO lleva "/learner" ni "/partner".
    final endpoint = '$baseUrl/profiles/$id';

    try {
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw ServerException('Perfil no encontrado');
      }
    } on DioException catch (e) {
      throw ServerException('Error al obtener perfil por ID: ${e.message}');
    }
  }
}