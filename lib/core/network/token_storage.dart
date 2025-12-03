import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  Future<Map<String, dynamic>?> decodeToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      print('Error decodificando token: $e');
      return null;
    }
  }

  /// Extrae un campo específico del token decodificado
  Future<T?> getTokenField<T>(String fieldName) async {
    final decoded = await decodeToken();
    return decoded?[fieldName] as T?;
  }

  /// Obtiene el learnerId del token
  Future<int?> getLearnerId() async {
    return await getTokenField<int>('learnerId');
  }

  Future<int?> getPartnerrId() async {
    return await getTokenField<int>('partnerId');
  }
}