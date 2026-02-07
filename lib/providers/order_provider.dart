import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> createOrder(Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _orderService.createOrder(order);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderService.getMyOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderService.getAllOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(orderId, newStatus);
      
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = Order(
          id: _orders[index].id,
          dateOrder: _orders[index].dateOrder,
          status: newStatus,
          total: _orders[index].total,
          tableNumber: _orders[index].tableNumber,
          orderLines: _orders[index].orderLines,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<Order> getActiveOrders() {
    return _orderService.getActiveOrders(_orders);
  }

  List<Order> getOrderHistory() {
    return _orderService.getCompletedOrders(_orders);
  }
}