import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/const/backend_urls.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfileByEmail(String email, String token);
  Future<ProfileModel> createProfile(Map<String, dynamic> profileData);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> getProfileByEmail(String email, String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/profiles/search?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- Usamos el token
      },
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el perfil');
    }
  }

  @override
  Future<ProfileModel> createProfile(Map<String, dynamic> profileData) async {
    // Este endpoint está abierto (sin token) según WebSecurityConfiguration
    final response = await client.post(
      Uri.parse('$baseUrl/profiles'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profileData),
    );

    if (response.statusCode == 201) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el perfil');
    }
  }
}