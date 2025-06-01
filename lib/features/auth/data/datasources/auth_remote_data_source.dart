import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart'; // Ajusta según estructura

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception('Error al iniciar sesión');
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



