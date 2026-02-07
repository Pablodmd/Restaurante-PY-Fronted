import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://restaurante-py-backend-kzg8.onrender.com";

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
      final token = data["token"];
      final role = data["role"]; 
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('role', role); 
      
      return token;
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    if (response.statusCode == 400) {
      final data = json.decode(response.body);
      final message = data["message"]?.toString().toLowerCase() ?? response.body.toLowerCase();
      
      if (message.contains("username") && message.contains("already")) {
        throw Exception("Ese nombre de usuario ya existe");
      }
      if (message.contains("email") && message.contains("already")) {
        throw Exception("Ese correo electrónico ya existe");
      }
      throw Exception(data["message"] ?? "Error al registrar usuario");
    }

    throw Exception("Error al registrar usuario");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}