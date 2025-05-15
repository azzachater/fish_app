import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import 'api_auth_service.dart';

class ApiOrderService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/orders';
  final ApiAuthService _authService = ApiAuthService();

  Future<List<Order>> getOrders() async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.get(Uri.parse(_baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Order.fromJson(json)).toList();
    }
    throw Exception('Failed to load orders');
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final headers = await _authService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: json.encode(orderData),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create order');
  }
}