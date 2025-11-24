import 'package:dio/dio.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor({required this.tokenStorage});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Buscamos el token guardado
    final token = await tokenStorage.getToken();

    // 2. Si existe, lo agregamos al Header igual que en Kotlin
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Continuamos con la petición
    super.onRequest(options, handler);
  }
  
  // Opcional: Manejar cuando el token vence (Error 401)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Aquí podrías redirigir al Login automáticamente
      print("Token vencido o inválido");
    }
    super.onError(err, handler);
  }
}