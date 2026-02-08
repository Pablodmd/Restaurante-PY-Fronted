import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderService {
  static const String _baseUrl = 'https://restaurante-py-backend-kzg8.onrender.com';

  String _mapStatus(String backendStatus) {
    switch (backendStatus.toUpperCase()) {
      case 'PENDING':
        return 'Pendiente';
      case 'IN_PROGRESS':
      case 'INPROGRESS':
        return 'En proceso';
      case 'COMPLETED':
        return 'Completado';
      case 'DELIVERED':
        return 'Entregado';
      default:
        return backendStatus;
    }
  }

  String _mapStatusToBackend(String appStatus) {
    switch (appStatus) {
      case 'Pendiente':
        return 'PENDING';
      case 'En proceso':
        return 'IN_PROGRESS';
      case 'Completado':
        return 'COMPLETED';
      case 'Entregado':
        return 'DELIVERED';
      default:
        return appStatus;
    }
  }

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

  Future<Order> createOrder(Order order) async {
    try {
      final headers = await _getHeaders();
      
      final orderJson = order.toJson();
      orderJson['status'] = _mapStatusToBackend(order.status);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: headers,
        body: json.encode(orderJson),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        data['status'] = _mapStatus(data['status']);
        return Order.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else {
        throw Exception('Error al crear el pedido: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<List<Order>> getMyOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
         Uri.parse('$_baseUrl/orders/me'),
         headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data.map((json) {
          json['status'] = _mapStatus(json['status']);
          return Order.fromJson(json);
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else {
        throw Exception('Error al obtener pedidos: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<List<Order>> getAllOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/orders'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data.map((json) {
          json['status'] = _mapStatus(json['status']);
          return Order.fromJson(json);
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else {
        throw Exception('Error al obtener pedidos: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final headers = await _getHeaders();
      
      final backendStatus = _mapStatusToBackend(newStatus);
      
      final response = await http.put(
        Uri.parse('$_baseUrl/admin/orders/$orderId/status'),
        headers: headers,
        body: json.encode({'status': backendStatus}),
      );

      if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión nuevamente');
      } else if (response.statusCode != 200) {
        throw Exception('Error al actualizar el estado: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se pudo conectar al servidor');
      }
      rethrow;
    }
  }

  List<Order> getActiveOrders(List<Order> orders) {
    return orders.where((order) => 
      order.status == 'Pendiente' || order.status == 'En proceso'
    ).toList();
  }

  List<Order> getCompletedOrders(List<Order> orders) {
    return orders.where((order) => 
      order.status == 'Completado' || order.status == 'Entregado'
    ).toList();
  }
}