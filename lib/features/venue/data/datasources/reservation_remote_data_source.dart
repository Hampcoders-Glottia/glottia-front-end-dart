import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:mobile_frontend/const/backend_urls.dart';
import '../models/table_model.dart';

abstract class ReservationRemoteDataSource {
  Future<List<TableModel>> getAvailableTables(
      int venueId, DateTime date, int guestCount);
  Future<bool> reserveTable(int tableId, DateTime date);
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final http.Client client;
  ReservationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TableModel>> getAvailableTables(
      int venueId, DateTime date, int guestCount) async {
    // Formateamos la fecha a YYYY-MM-DD como espera el backend
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    
    final url = Uri.parse(
        '$baseUrl/venues/$venueId/tables/available?date=$formattedDate&minCapacity=$guestCount');

    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      // TODO: Añadir token de autorización si es necesario
      // 'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TableModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar mesas disponibles');
    }
  }

  @override
  Future<bool> reserveTable(int tableId, DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.parse('$baseUrl/tables/$tableId/reservations');

    final response = await client.patch( // Nota: Es un PATCH
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'reservationDate': formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Éxito
    } else {
      throw Exception('Error al reservar la mesa');
    }
  }
}