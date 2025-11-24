import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/core/error/failures.dart';
import '../../../../const/backend_urls.dart';
import '../models/loyalty_stats_model.dart';
import '../models/encounter_model.dart';

abstract class DashboardRemoteDataSource {
  Future<LoyaltyStatsModel> getLoyaltyStats(String token);
  Future<List<EncounterModel>> getUpcomingEncounters(String token);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<LoyaltyStatsModel> getLoyaltyStats(String token) async {
    // Endpoint definido en LoyaltyController.java
    final response = await client.get(
      Uri.parse('$baseUrl/loyalty/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return LoyaltyStatsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<List<EncounterModel>> getUpcomingEncounters(String token) async {
    // Usamos el endpoint de búsqueda de EncountersController.java
    // Filtramos por fecha actual para ver los futuros
    final now = DateTime.now().toIso8601String().split('T')[0]; // yyyy-MM-dd
    
    // NOTA: Los parámetros languageId y cefrLevelId son obligatorios en tu backend actual.
    // Para esta primera versión, hardcodearemos valores (ej. 1 para inglés) o 
    // tendrás que hacer opcionales esos filtros en el backend.
    final queryParams = {
      'date': now,
      'location': 'Lima', // Placeholder requerido
      'languageId': '1',  // Placeholder
      'cefrLevelId': '1', // Placeholder
    };

    final uri = Uri.parse('$baseUrl/encounters/search').replace(queryParameters: queryParams);

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => EncounterModel.fromJson(json)).toList();
    } else {
      throw ServerFailure();
    }
  }
}