import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // NUEVO: Crear producto
  Future<void> createProduct(Product product) async {
    try {
      await _productService.createProduct(product);
      await loadProducts(); // Recargar la lista
    } catch (e) {
      rethrow;
    }
  }

  // NUEVO: Actualizar producto
  Future<void> updateProduct(int id, Product product) async {
    try {
      await _productService.updateProduct(id, product);
      await loadProducts(); // Recargar la lista
    } catch (e) {
      rethrow;
    }
  }

  // NUEVO: Eliminar producto
  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      await loadProducts(); // Recargar la lista
    } catch (e) {
      rethrow;
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _productService.filterByCategory(_products, category);
  }
}