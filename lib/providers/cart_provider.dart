import 'package:flutter/material.dart';
import '../models/order_line.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<OrderLine> _items = [];

  List<OrderLine> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void addProduct(Product product, {String? notes}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.notes == notes
    );

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        amount: existingItem.amount + 1,
        subtotal: (existingItem.amount + 1) * product.price,
      );
    } else {
      _items.add(OrderLine(
        amount: 1,
        price: product.price,
        subtotal: product.price,
        notes: notes,
        product: product,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newAmount) {
    if (newAmount <= 0) {
      removeItem(index);
      return;
    }

    final item = _items[index];
    _items[index] = item.copyWith(
      amount: newAmount,
      subtotal: newAmount * item.price,
    );
    notifyListeners();
  }

  void updateNotes(int index, String notes) {
    final item = _items[index];
    _items[index] = item.copyWith(notes: notes);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}