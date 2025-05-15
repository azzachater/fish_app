import 'order_item.dart';

class Order {
  final int id;
  // ignore: non_constant_identifier_names
  final int buyer_id;
  final String status;
  final String paymentMethod;
  final String address;
  final String phone;
  final double total;
  final DateTime? createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.buyer_id,
    this.status = 'pending',
    required this.paymentMethod,
    required this.address,
    required this.phone,
    required this.total,
    this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
  double parseTotal(dynamic totalValue) {
    if (totalValue is String) {
      return double.tryParse(totalValue) ?? 0.0;
    } else if (totalValue is num) {
      return totalValue.toDouble();
    } else {
      return 0.0;
    }
  }

  String parseString(dynamic value) {
    if (value == null) {
      return '';
    } else if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  return Order(
    id: json['id'] as int,
    buyer_id: json['buyer_id'] as int,
    status: parseString(json['status']).isNotEmpty ? parseString(json['status']) : 'pending',
    paymentMethod: parseString(json['payment_method']),
    address: parseString(json['address']),
    phone: parseString(json['phone']),
    total: parseTotal(json['total']),
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'] as String) 
        : null,
    items: (json['items'] as List<dynamic>?)
        ?.map((item) => OrderItem.fromJson(item))
        .toList() ?? [],
  );
}


}