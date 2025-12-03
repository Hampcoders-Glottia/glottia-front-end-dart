import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../const/backend_urls.dart'; 
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token_storage.dart'; // Para obtener el token
import '../models/encounter_model.dart';
import '../models/loyalty_stats_model.dart';
import '../models/loyalty_transaction_model.dart';

abstract class DashboardRemoteDataSource {
  Future<LoyaltyStatsModel> getLoyaltyStats(int learnerId);
  Future<List<EncounterModel>> getUpcomingEncounters(int learnerId);
  Future<List<EncounterModel>> getEncounterHistory(int learnerId); // Nuevo
  Future<List<LoyaltyTransactionModel>> getPointsHistory(int learnerId, {int page = 0, int size = 10});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage; 

  DashboardRemoteDataSourceImpl({required this.client, required this.tokenStorage});

  // Helper para headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await tokenStorage.getToken();
    print('Token obtenido: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<LoyaltyStatsModel> getLoyaltyStats(int learnerId) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/loyalty/me'),  // Endpoint /me para el usuario autenticado
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Opcional: Valida que learnerId coincida con el del JWT o la respuesta
      final decodedLearnerId = await tokenStorage.getLearnerId();
      if (decodedLearnerId != null && jsonResponse['learnerId'] != decodedLearnerId) {
        throw ServerException();  // O maneja el error
      }
      return LoyaltyStatsModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
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

  @override
  Future<List<LoyaltyTransactionModel>> getPointsHistory(int learnerId, {int page = 0, int size = 10}) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/loyalty/learners/$learnerId/points-history?page=$page&size=$size';
    print('Iniciando petición a: $url');
    final response = await client.get(Uri.parse(url), headers: headers);
    print('Código de estado: ${response.statusCode}');
    print('Respuesta del body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> content = jsonResponse['content'] as List<dynamic>;
      print('Número de transacciones obtenidas: ${content.length}');
      return content.map((e) => LoyaltyTransactionModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      print('Error en la respuesta: ${response.body}');
      throw ServerException();
    }
  }


}