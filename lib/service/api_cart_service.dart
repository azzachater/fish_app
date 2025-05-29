import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fish_app/models/product.dart';
import 'api_auth_service.dart';

class CartService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.13:8000/api/cart';

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
    debugPrint('🔄 Attempting to update quantity for product ${product.id} to $newQuantity');
    
    // 1. D'abord récupérer le panier complet pour trouver le cart_id
    final cartResponse = await http.get(
      Uri.parse(baseUrl),
      headers: await _getAuthHeaders(),
    );

    if (cartResponse.statusCode != 200) {
      throw Exception('Failed to fetch cart items');
    }

    final cartData = jsonDecode(cartResponse.body);
    final cartItem = (cartData['cart'] as List).firstWhere(
      (item) => item['product']['id'].toString() == product.id.toString(),
      orElse: () => null,
    );

    if (cartItem == null) {
      throw Exception('Product not found in cart');
    }

    final cartId = cartItem['id'];
    debugPrint('🔍 Found cart ID: $cartId for product ${product.id}');

    // 2. Maintenant faire la mise à jour avec le cart_id
    final response = await http.put(
      Uri.parse('$baseUrl/$cartId'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({
        'quantity': newQuantity,
        // Ajoutez d'autres champs requis par votre API
      }),
    );

    debugPrint('📦 Update response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Update failed: ${response.body}');
    }
  } catch (e, stackTrace) {
    debugPrint('''
❌ Critical error updating quantity:
Error: $e
Stack trace: $stackTrace
''');
    rethrow;
  }
}

  Future<bool> removeFromCart(String productId) async {
    debugPrint('🔄 Attempting to remove product $productId from cart');
    try {
      // D'abord récupérer les items du panier pour trouver le cart_id correspondant
      final cartItemsResponse = await http.get(
        Uri.parse(baseUrl),
        headers: await _getAuthHeaders(),
      );

      if (cartItemsResponse.statusCode != 200) {
        throw Exception('Failed to fetch cart items');
      }

      final cartData = jsonDecode(cartItemsResponse.body);
      final cartItems = (cartData['cart'] as List);

      // Trouver l'item correspondant au productId
      final cartItem = cartItems.firstWhere(
        (item) => item['product']['id'].toString() == productId,
        orElse: () => null,
      );

      if (cartItem == null) {
        throw Exception('Product not found in cart');
      }

      final cartId = cartItem['id'];
      debugPrint('🔍 Found cart ID: $cartId for product $productId');

      // Maintenant faire la suppression avec le cart_id
      final response = await http.delete(
        Uri.parse('$baseUrl/$cartId'),
        headers: await _getAuthHeaders(),
      );

      debugPrint(
        '🗑️ Remove response: ${response.statusCode} - ${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error removing from cart: $e');
      rethrow;
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
        Uri.parse('$baseUrl/checkout'),
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
        // Gestion des erreurs spécifiques
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('product_id')) {
          throw Exception('Stock insuffisant pour un produit');
        }
        throw Exception('Failed to place order: ${response.body}');
      }
    } catch (e) {
      print('Place order error: $e');
      rethrow;
    }
  }

  //pour verifier le stock 9bal manhotouh fel cart
  Future<Map<String, dynamic>> checkStock(
    String productId,
    int quantity,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.13:8000/api/products/$productId/check-stock/$quantity',
        ),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Stock check response: $data'); // Log important
        return data;
      } else {
        throw Exception('HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Check stock error: $e');
      rethrow;
    }
  }
}