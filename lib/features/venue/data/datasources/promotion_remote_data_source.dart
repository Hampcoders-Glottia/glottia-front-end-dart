import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../const/backend_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token_storage.dart';
import '../models/promotion_model.dart';
import '../../domain/entities/promotion.dart';

abstract class PromotionRemoteDataSource {
  Future<List<PromotionModel>> getPromotionsByVenue(int venueId);
  Future<bool> createPromotion(int venueId, Promotion promotion, int partnerId);
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
  Future<bool> createPromotion(int venueId, Promotion promotion, int partnerId) async {
    final token = await tokenStorage.getToken();
    final urlCreate = Uri.parse('$baseUrl/promotions'); // Endpoint de creación global o anidado
    
    final bodyCreate = json.encode({
      'name': promotion.name,
      'description': promotion.description,
      'validFrom': promotion.startDate.toIso8601String(), 
      'validUntil': promotion.endDate.toIso8601String(),
      'value': promotion.discountPercentage,
      'promotionType': "DISCOUNT_PERCENT", 
      'partnerId': partnerId,
    });

    final responseCreate = await client.post(
      urlCreate,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: bodyCreate,
    );

    if (responseCreate.statusCode != 201) {
        // Log para depuración
        print("Error creando promo: ${responseCreate.body}");
        throw ServerException();
    }
    
    final promoId = json.decode(responseCreate.body)['id'];

    // 2. Asignarla al Venue
    final urlAssign = Uri.parse('$baseUrl/venues/$venueId/promotions');
    
    final bodyAssign = json.encode({
      'promotionId': promoId,
      'validFrom': promotion.startDate.toIso8601String(),
      'validUntil': promotion.endDate.toIso8601String(),
      'maxRedemptions': 100
    });

    final responseAssign = await client.post(
      urlAssign,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: bodyAssign,
    );

    if (responseAssign.statusCode == 201) {
      return true;
    } else {
      print("Error asignando promo: ${responseAssign.body}");
      throw ServerException();
    }
  }
}