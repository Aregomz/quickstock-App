import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart'; // Ajusta según estructura

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  Future<String> login(String email, String password) async {
    print('AuthRemoteDataSource - Iniciando petición de login');
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('AuthRemoteDataSource - Respuesta recibida: ${response.statusCode}');
      print('AuthRemoteDataSource - Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['token'] as String?;
        
        if (token == null || token.isEmpty) {
          throw Exception('Token no encontrado en la respuesta');
        }
        
        print('AuthRemoteDataSource - Token extraído: $token');
        return token;
      } else {
        final errorBody = response.body.isNotEmpty ? response.body : 'Sin mensaje de error';
        throw Exception('Error en login: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('AuthRemoteDataSource - Error en login: $e');
      rethrow;
    }
  }

Future<void> register(String email, String password) async {
  final response = await client.post(
    Uri.parse('$baseUrl/api/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    final errorBody = response.body.isNotEmpty ? response.body : 'No message';
    throw Exception('Error al registrar usuario: ${response.statusCode} - $errorBody');
  }
}


}



