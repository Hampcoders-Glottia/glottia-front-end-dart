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
      // TODO: Para producción, deberíamos obtener el ID real del usuario logueado.
      // Por ahora, usamos 1 (que suele ser el learner creado por defecto o en tus pruebas)
      // para asegurar que el backend no rechace la petición.
      const int hardcodedCreatorId = 1; 

      final response = await dio.post(
        endpoint,
        data: {
          "creatorId": hardcodedCreatorId,
          "venueId": params.venueId,
          "topic": params.topic,
          "language": params.language,   // Ej: "ENGLISH" (Debe coincidir con el Enum del backend)
          "cefrLevel": params.level,     // Ej: "B1" (Debe coincidir con el Enum del backend)
          "scheduledAt": params.scheduledAt.toIso8601String(), // Formato ISO-8601
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      // Puedes inspeccionar e.response para ver errores específicos del backend
      throw ServerException();
    }
  }
}