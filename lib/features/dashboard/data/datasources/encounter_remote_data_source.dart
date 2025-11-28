import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import 'package:mobile_frontend/core/error/exceptions.dart';
import '../../domain/entities/encounter_creation_params.dart';
import '../models/encounter_model.dart';

abstract class EncounterRemoteDataSource {
  Future<bool> createEncounter(EncounterCreationParams params);
  Future<List<EncounterModel>> searchEncounters({
    String? date,
    String? location,
    int? languageId,
    int? cefrLevelId,
    int page,
    int size,
  });
}

class EncounterRemoteDataSourceImpl implements EncounterRemoteDataSource {
  final Dio dio;

  EncounterRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> createEncounter(EncounterCreationParams params) async {
    final endpoint = '$baseUrl/encounters';

    try {
      // CORRECCIÓN: Usamos el creatorId que viene en los parámetros (ID real)
      // El venueId también debe ser real (vendrá de una selección previa o lo dejaremos como 1 si solo hay un local de prueba)
      
      final response = await dio.post(
        endpoint,
        data: {
          "creatorId": params.creatorId, // <--- ID REAL
          "venueId": params.venueId,
          "topic": params.topic,
          "language": params.language,
          "cefrLevel": params.level,
          "scheduledAt": params.scheduledAt.toIso8601String(),
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw ServerException();
      }
    } on DioException {
      // Puedes inspeccionar e.response para ver errores específicos del backend
      throw ServerException();
    }
  }

  @override
  Future<List<EncounterModel>> searchEncounters({
    String? date,
    String? location,
    int? languageId,
    int? cefrLevelId,
    int page = 0,
    int size = 10,
  }) async {
    // Construir query parameters
    final Map<String, dynamic> queryParams = {
      'page': page,
      'size': size,
    };
    if (date != null) queryParams['date'] = date;
    // if (location != null) queryParams['location'] = location; // Comentado temporalmente por el backend
    if (languageId != null) queryParams['languageId'] = languageId;
    if (cefrLevelId != null) queryParams['cefrLevelId'] = cefrLevelId;

    final response = await dio.get(
      // Asegúrate que esta ruta coincida con tu backend (/api/v1/encounters/search o similar)
      '$baseUrl/encounters/search', 
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      // Si el backend devuelve una Page (content: []), accedemos a 'content'
      // Si devuelve una lista directa, usa response.data
      final List<dynamic> content = response.data['content'] ?? response.data; 
      
      return content.map((json) => EncounterModel.fromJson(json)).toList();
    } else {
      throw Exception('Error searching encounters'); // Usa tus propias ServerException
    }
  }
}