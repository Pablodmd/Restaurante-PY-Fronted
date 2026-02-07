import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static const String _baseUrl = 'https://restaurante-py-backend-kzg8.onrender.com';

  // Método para obtener el token almacenado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Headers con autenticación
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Obtener todos los usuarios
  Future<List<User>> getAllUsers() async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/admin/users'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 403) {
        throw Exception('No tienes permisos de administrador');
      } else {
        throw Exception('Error al obtener usuarios: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  // Obtener usuario por ID
  Future<User> getUserById(int id) async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/admin/users/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error al obtener usuario: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  // Eliminar usuario
  Future<void> deleteUser(int id) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$_baseUrl/admin/users/$id'),
        headers: headers,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 403) {
        throw Exception('No tienes permisos para eliminar usuarios');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error al eliminar usuario: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }
}