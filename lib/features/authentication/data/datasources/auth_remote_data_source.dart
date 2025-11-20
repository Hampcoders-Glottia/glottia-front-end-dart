import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/const/backend_urls.dart';
import '../../../../core/error/exceptions.dart'; 
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': email, // Mapeamos email a 'username' según backend
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(); // Credenciales incorrectas
    } else {
      // Intentamos obtener el mensaje del servidor si existe, sino lanzamos error genérico
      throw ServerException();
    }
  }

  @override
  Future<void> register(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': email, 
        'password': password
      }),
    );

    // El backend devuelve 201 Created al registrarse exitosamente
    if (response.statusCode != 201) {
      // Aquí podrías decodificar el body si el backend dice "Usuario ya existe"
      throw ServerException();
    }
  }
}