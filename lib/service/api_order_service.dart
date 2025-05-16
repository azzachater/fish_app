import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'api_auth_service.dart';
import '../models/order.dart';

class ApiOrderService {
  final ApiAuthService _authService;
  final String baseUrl;

  ApiOrderService({
    ApiAuthService? authService,
    String? baseUrl,
  })  : _authService = authService ?? ApiAuthService(),
        baseUrl = baseUrl ?? 'http://192.168.1.13:8000/api';

  // Headers de base (sans auth)
  static const Map<String, String> _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final headers = Map<String, String>.from(_baseHeaders);
      final authHeaders = await _authService.getAuthHeaders();
      
      headers.addAll(authHeaders); // Fusion des headers
      debugPrint("🔵 Auth Headers: $headers");
      
      return headers;
    } catch (e) {
      debugPrint('❌ Failed to get auth headers: $e');
      throw Exception('Authentication headers error');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: await _getAuthHeaders(),
      );

      debugPrint('📦 Orders Response: ${response.statusCode} - ${response.body}');

      return _handleResponse<List<Order>>(
        response,
        parse: (data) => (data as List).map((json) => Order.fromJson(json)).toList(),
        successCode: 200,
        errorMessage: 'Failed to fetch orders',
      );
    } catch (e) {
      debugPrint('❌ getOrders error: $e');
      rethrow;
    }
  }

  Future<Order> createOrder({
    required String phone,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: await _getAuthHeaders(),
        body: json.encode({
          'phone': phone,
          'address': address,
          'payment_method': paymentMethod,
        }),
      );

      debugPrint('📤 Create Order Response: ${response.statusCode} - ${response.body}');

      return _handleResponse<Order>(
        response,
        parse: (data) => Order.fromJson(data),
        successCode: 201,
        errorMessage: 'Failed to create order',
      );
    } catch (e) {
      debugPrint('❌ createOrder error: $e');
      rethrow;
    }
  }

  Future<Order> getOrderDetails(String orderId) async {
    try {
      if (orderId.isEmpty) throw ArgumentError('Order ID cannot be empty');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: await _getAuthHeaders(),
      );

      debugPrint('📄 Order Details Response: ${response.statusCode} - ${response.body}');

      return _handleResponse<Order>(
        response,
        parse: (data) => Order.fromJson(data),
        successCode: 200,
        errorMessage: 'Failed to fetch order details',
      );
    } catch (e) {
      debugPrint('❌ getOrderDetails error: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      if (orderId.isEmpty) throw ArgumentError('Order ID cannot be empty');

      final response = await http.delete(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: await _getAuthHeaders(),
      );

      debugPrint('🗑️ Cancel Order Response: ${response.statusCode}');

      _handleResponse<void>(
        response,
        successCode: 204,
        errorMessage: 'Failed to cancel order',
      );
    } catch (e) {
      debugPrint('❌ cancelOrder error: $e');
      rethrow;
    }
  }

  // Gestion centralisée des réponses
  T _handleResponse<T>(
    http.Response response, {
    required int successCode,
    required String errorMessage,
    T Function(dynamic)? parse,
  }) {
    debugPrint('🔴 Raw Response: ${response.statusCode} - ${response.body}');

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == successCode) {
        return parse != null ? parse(data) : null as T;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(data['message'] ?? data['error'] ?? errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Response parsing error: $e');
      throw Exception('$errorMessage: ${e.toString()}');
    }
  }
}