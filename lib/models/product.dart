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
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      available: json['available'],
      preparationTime: json['preparationTime'].toDouble(),
    );
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