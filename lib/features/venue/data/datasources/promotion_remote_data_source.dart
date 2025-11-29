import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../const/backend_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token_storage.dart';
import '../models/promotion_model.dart';
import '../../domain/entities/promotion.dart';

abstract class PromotionRemoteDataSource {
  Future<List<PromotionModel>> getPromotionsByVenue(int venueId);
  Future<bool> createPromotion(int venueId, Promotion promotion);
}

class PromotionRemoteDataSourceImpl implements PromotionRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  PromotionRemoteDataSourceImpl({required this.client, required this.tokenStorage});

  @override
  Future<List<PromotionModel>> getPromotionsByVenue(int venueId) async {
    final token = await tokenStorage.getToken();
    // Endpoint asumido según tu estructura: /api/v1/venues/{venueId}/promotions
    // O si usas endpoint global con filtro, ajústalo.
    final url = Uri.parse('$baseUrl/venues/$venueId/promotions'); 
    
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PromotionModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> createPromotion(int venueId, Promotion promotion) async {
    final token = await tokenStorage.getToken();
    final url = Uri.parse('$baseUrl/promotions'); // Endpoint de creación global o anidado
    
    final body = json.encode({
      ... (promotion as PromotionModel).toJson(),
      'venueId': venueId, // Enviamos el venueId en el body o en la URL según tu backend
    });

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}