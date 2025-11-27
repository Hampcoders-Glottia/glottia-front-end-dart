import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import 'package:mobile_frontend/core/error/exceptions.dart';
import '../../domain/entities/encounter_creation_params.dart';

abstract class EncounterRemoteDataSource {
  Future<bool> createEncounter(EncounterCreationParams params);
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
}