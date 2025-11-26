import 'package:dio/dio.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
import 'package:mobile_frontend/core/error/exceptions.dart';

class VenueRemoteDataSource {
  final Dio dio;

  VenueRemoteDataSource({required this.dio});

  // 1. Crear un Venue (Local)
  Future<int> createVenue(Map<String, dynamic> venueData) async {
    try {
      final response = await dio.post(
        '$baseUrl/venues',
        data: venueData,
      );
      if (response.statusCode == 201) {
        return response.data['venueId']; // Asumiendo que devuelve el ID o el objeto
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  // 2. Asociar Venue al Partner (Registro)
  Future<void> addVenueToPartnerRegistry(int partnerId, int venueId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await dio.post(
        '$baseUrl/partner-venue-registries/$partnerId/venues',
        data: {
          "venueId": venueId,
          "registrationDate": now,
          "isActive": true
        },
      );
    } catch (e) {
      throw ServerException();
    }
  }

  // 3. Obtener Venues del Partner
  Future<List<dynamic>> getPartnerVenues(int partnerId) async {
    try {
      final response = await dio.get(
        '$baseUrl/partner-venue-registries/$partnerId/venues',
      );
      return response.data ?? [];
    } catch (e) {
      // Si falla (ej. 404 porque no tiene venues), retornamos lista vacía
      return [];
    }
  }
  
  // 4. Obtener Tipos de Venue (Metadata)
  Future<List<dynamic>> getVenueTypes() async {
    try {
      final response = await dio.get('$baseUrl/venues/metadata/venue-types');
      return response.data;
    } catch (e) {
      return [];
    }
  }
}