import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response_model.dart';
import 'package:mobile_frontend/const/backend_urls.dart';
// (Necesitarás crear un user_model.dart para la respuesta de /sign-up)
// import '../models/user_model.dart'; 

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> register(String email, String password); // /sign-up devuelve 201, no un body
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error de autenticación'); // Debería ser un ServerException
    }
  }

  @override
  Future<void> register(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': email, 'password': password}),
    );
    
    // El backend de /sign-up devuelve 201 CREATED
    if (response.statusCode != 201) { 
      throw Exception('Error al registrar usuario en IAM');
    }
    // No devuelve cuerpo, así que retornamos void
  }
}