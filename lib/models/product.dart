class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String category;
  final bool available;
  final double preparationTime;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.available,
    required this.preparationTime,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      available: json['available'] ?? true,
      preparationTime: (json['preparationTime'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'available': available,
      'preparationTime': preparationTime,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'available': available,
      'preparationTime': preparationTime,
    };
  }
}