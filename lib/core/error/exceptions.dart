/// Excepción genérica para errores del servidor (ej. 500, respuesta inválida)
class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

/// Excepción para cuando falla la caché local o base de datos local
class CacheException implements Exception {}

/// Excepción específica para error 401 (Credenciales inválidas / Token vencido)
class UnauthorizedException implements Exception {
  final String? message;
  UnauthorizedException([this.message]);
}

/// Excepción para cuando no hay conexión a internet y se intenta una operación online
class OfflineException implements Exception {}