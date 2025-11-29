import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import '../models/loyalty_stats_model.dart';
import '../models/encounter_model.dart';

abstract class DashboardRemoteDataSource {
  Future<LoyaltyStatsModel> getLoyaltyStats();
  Future<List<EncounterModel>> getUpcomingEncounters(int learnerId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio; 

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoyaltyStatsModel> getLoyaltyStats() async {
    const endpoint = '$baseUrl/loyalty/me';

    try {
      // Dio ya incluye el token gracias al AuthInterceptor configurado
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        return LoyaltyStatsModel.fromJson(response.data);
      } else {
        // Si el status no es 200 (ej. 404 porque no tiene cuenta de lealtad aún),
        // devolvemos valores en cero para no bloquear la UI.
        return const LoyaltyStatsModel(points: 0, encountersAttended: 0);
      }
    } catch (e) {
      // Si ocurre un error de conexión o del servidor, devolvemos stats vacíos
      print("⚠️ Error obteniendo stats (usando default): $e");
      return const LoyaltyStatsModel(points: 0, encountersAttended: 0);
    }
  }

@override
  Future<List<EncounterModel>> getUpcomingEncounters(int learnerId) async {
    // Usamos un endpoint específico para las reservas de ESTE alumno
    final endpoint = '$baseUrl/encounters/learner/$learnerId/upcoming'; 

    try {
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => EncounterModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("⚠️ Error obteniendo reservas: $e");
      return [];
    }
  }
}