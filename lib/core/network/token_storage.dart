import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Usamos flutter_secure_storage para máxima seguridad
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // Obtener el token (equivale a jwtStorage.getToken() en Kotlin)
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Guardar el token (equivale a jwtStorage.setToken() en Kotlin)
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Borrar token al cerrar sesión
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}