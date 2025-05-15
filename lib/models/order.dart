import 'order_item.dart';

class Order {
  final int id;
  final int buyerId;
  final String status;
  final String paymentMethod;
  final String shippingAddress;
  final String phone;
  final double total;
  final DateTime? createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.buyerId,
    this.status = 'pending',
    required this.paymentMethod,
    required this.shippingAddress,
    required this.phone,
    required this.total,
    this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      buyerId: json['buyer_id'] as int,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String,
      shippingAddress: json['shipping_address'] as String,
      phone: json['phone'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}