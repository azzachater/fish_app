import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fish_app/models/product.dart';
import 'api_auth_service.dart';

class CartService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.52:8000/api/cart';

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';
    return headers;
  }

  Future<List<Product>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['cart'] as List)
            .map((item) => Product.fromJson(item['product']))
            .toList();
      }
      throw Exception('Failed to load cart: ${response.statusCode}');
    } catch (e) {
      print('Error getting cart: $e');
      rethrow;
    }
  }

  Future<bool> addToCart(Product product, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'product_id': product.id, 'quantity': quantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> updateQuantity(Product product, int newQuantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'quantity': newQuantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(Product product) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/${product.id}'),
        headers: await _getAuthHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  Future<bool> placeOrder({
    required String phone,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: headers,
        body: jsonEncode({
          'phone': phone,
          'address': address,
          'payment_method': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to place order: ${response.body}');
      }
    } catch (e) {
      print('Place order error: $e');
      rethrow;
    }
  }
  //pour verifier le stock 9bal manhotouh fel cart
  Future<Map<String, dynamic>> checkStock(String productId, int quantity) async {
  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/check-stock/$quantity'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check stock');
    }
  } catch (e) {
    print('Check stock error: $e');
    rethrow;
  }
}
}
