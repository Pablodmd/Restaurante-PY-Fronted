import 'product.dart';

class OrderLine {
  final int? id;
  final int amount;
  final double price;
  final double subtotal;
  final String? notes;
  final Product product;

  OrderLine({
    this.id,
    required this.amount,
    required this.price,
    required this.subtotal,
    this.notes,
    required this.product,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'],
      amount: json['amount'],
      price: json['price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      notes: json['notes'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'price': price,
      'subtotal': subtotal,
      'notes': notes,
      'product': product.toJson(),
    };
  }

  OrderLine copyWith({
    int? id,
    int? amount,
    double? price,
    double? subtotal,
    String? notes,
    Product? product,
  }) {
    return OrderLine(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      subtotal: subtotal ?? this.subtotal,
      notes: notes ?? this.notes,
      product: product ?? this.product,
    );
  }
}