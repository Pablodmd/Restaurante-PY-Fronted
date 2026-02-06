import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://restaurante-py-backend-kzg8.onrender.com"; // ⚠️ cambia esto

  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["token"];
    } else {
      throw Exception("Usuario o contraseña incorrectos");
    }
  }

  static Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return;
    }

    final message = response.body.toLowerCase();

    if (message.contains("username is already taken")) {
      throw Exception("Ese nombre de usuario ya existe");
    }

    throw Exception("Error al registrar usuario");
  }

}
