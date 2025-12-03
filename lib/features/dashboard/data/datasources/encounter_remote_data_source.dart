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
    String? topic,
    int page,
    int size,
  });
  Future<List<EncounterModel>> getEncountersByLearnerId(int learnerId);
}

class EncounterRemoteDataSourceImpl implements EncounterRemoteDataSource {
  final Dio dio;

  EncounterRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> createEncounter(EncounterCreationParams params) async {
    print('Llamada a createEncounter en data source con topic: ${params.topic}'); // Agregar aquí
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
    String? topic,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // Construir query parameters
      final Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };
      if (date != null) queryParams['date'] = date;
      if (languageId != null) queryParams['languageId'] = languageId;
      if (cefrLevelId != null) queryParams['cefrLevelId'] = cefrLevelId;
      if (topic != null && topic.isNotEmpty) queryParams['topic'] = topic;

      print('🌐 Llamando a: $baseUrl/encounters/search-simple');
      print('📝 Query params: $queryParams');

      final response = await dio.get(
        '$baseUrl/encounters/search-simple',
        queryParameters: queryParams,
      );

      print('✅ Status code: ${response.statusCode}');
      print('📦 Tipo de data: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        List<dynamic> content;

        // El backend puede devolver:
        // 1. Un array directo: [{...}, {...}]
        // 2. Un objeto con content: {content: [{...}], totalPages: ...}
        if (response.data is List) {
          print('📋 Respuesta es lista directa');
          content = response.data as List<dynamic>;
        } else if (response.data is Map && response.data['content'] != null) {
          print('📋 Respuesta tiene campo "content"');
          content = response.data['content'] as List<dynamic>;
        } else {
          print('⚠️ Formato de respuesta inesperado');
          content = [];
        }

        print('📊 Parseando ${content.length} encounters...');

        final encounters = content
            .map((json) {
              try {
                return EncounterModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parseando encounter: $e');
                return null;
              }
            })
            .whereType<EncounterModel>()
            .toList();

        print('✅ ${encounters.length} encounters parseados correctamente');
        return encounters;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('📄 Response: ${e.response?.data}');
      throw ServerException();
    } catch (e, stackTrace) {
      print('❌ Error inesperado en searchEncounters: $e');
      print('📚 Stack trace: $stackTrace');
      throw ServerException();
    }
  }

  @override
  Future<List<EncounterModel>> getEncountersByLearnerId(int learnerId) async {
    try {
      final response = await dio.get('$baseUrl/encounters/by-learner/$learnerId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EncounterModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }
}