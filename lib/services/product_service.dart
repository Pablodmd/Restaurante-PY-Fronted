import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://restaurante-py-backend-kzg8.onrender.com';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

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

  Future<List<Product>> getAllProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/users/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else {
        throw Exception('Error al obtener productos: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final headers = await _getHeaders();
      
      final body = json.encode(product.toJsonCreate());
      
      final response = await http.post(
        Uri.parse('$_baseUrl/admin/products'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 403) {
        throw Exception('No tienes permisos de administrador');
      } else {
        throw Exception('Error al crear producto: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final headers = await _getHeaders();
      
      final body = json.encode(product.toJsonCreate()); 
 
      final response = await http.put(
        Uri.parse('$_baseUrl/admin/products/$id'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 403) {
        throw Exception('No tienes permisos de administrador');
      } else {
        throw Exception('Error al actualizar producto: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
     
      final response = await http.delete(
        Uri.parse('$_baseUrl/admin/products/$id'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode == 403) {
        throw Exception('No tienes permisos de administrador');
      } else {
        throw Exception('Error al eliminar producto: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  List<Product> filterByCategory(List<Product> products, String category) {
    return products.where((product) => 
      product.category.toLowerCase() == category.toLowerCase() && 
      product.available
    ).toList();
  }
}