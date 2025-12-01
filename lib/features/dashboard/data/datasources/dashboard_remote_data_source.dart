import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../const/backend_urls.dart'; 
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token_storage.dart'; // Para obtener el token
import '../models/encounter_model.dart';
import '../models/loyalty_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<LoyaltyStatsModel> getLoyaltyStats(int learnerId);
  Future<List<EncounterModel>> getUpcomingEncounters(int learnerId);
  Future<List<EncounterModel>> getEncounterHistory(int learnerId); // Nuevo
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage; 

  DashboardRemoteDataSourceImpl({required this.client, required this.tokenStorage});

  // Helper para headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<LoyaltyStatsModel> getLoyaltyStats(int learnerId) async {
    // ... (Tu implementación existente para stats)
    // Retorno mock por ahora si no tienes el endpoint listo
    return const LoyaltyStatsModel(points: 450, encountersAttended: 15); 
  }

  @override
  Future<List<EncounterModel>> getUpcomingEncounters(int learnerId) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/encounters/learner/$learnerId/upcoming'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => EncounterModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EncounterModel>> getEncounterHistory(int learnerId) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/encounters/learner/$learnerId/history'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => EncounterModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }
}