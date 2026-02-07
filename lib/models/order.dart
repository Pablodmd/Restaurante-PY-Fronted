import 'order_line.dart';

class Order {
  final int? id;
  final DateTime? dateOrder;
  final String status;
  final double total;
  final int tableNumber;
  final List<OrderLine> orderLines;

  Order({
    this.id,
    this.dateOrder,
    required this.status,
    required this.total,
    required this.tableNumber,
    required this.orderLines,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      dateOrder: json['dateOrder'] != null 
          ? DateTime.parse(json['dateOrder']) 
          : null,
      status: json['status'],
      total: json['total'].toDouble(),
      tableNumber: json['tableNumber'],
      orderLines: (json['orderLines'] as List)
          .map((line) => OrderLine.fromJson(line))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateOrder': dateOrder?.toIso8601String(),
      'status': status,
      'total': total,
      'tableNumber': tableNumber,
      'orderLines': orderLines.map((line) => line.toJson()).toList(),
    };
  }
}