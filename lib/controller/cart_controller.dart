// cart_controller.dart
import 'package:fish_app/screens/marketplace/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/service/api_cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  var cartItems = <Product>[].obs;
  var isLoading = false.obs;
  final RxString checkoutPhone = ''.obs;
  final RxString checkoutAddress = ''.obs;
  final RxString paymentMethod = ''.obs;

  // Méthode pour mettre à jour les infos de checkout
  void updateCheckoutInfo({String? phone, String? address, String? method}) {
    if (phone != null) checkoutPhone.value = phone;
    if (address != null) checkoutAddress.value = address;
    if (method != null) paymentMethod.value = method;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading(true);
      final items = await _cartService.getCartItems();
      cartItems.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cart items');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      // Vérifier le stock d'abord
      final stockCheck = await _cartService.checkStock(
        product.id.toString(),
        quantity,
      );

      if (!stockCheck['available']) {
        Get.snackbar(
          'Stock insuffisant',
          'Il ne reste que ${stockCheck['current_stock']} unités disponibles',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      // Ajout côté serveur
      final success = await _cartService.addToCart(product, quantity);

      if (success) {
        // Mise à jour côté client
        final existingIndex = cartItems.indexWhere((p) => p.id == product.id);
        if (existingIndex >= 0) {
          cartItems[existingIndex].quantity += quantity;
        } else {
          cartItems.add(product.copyWith(quantity: quantity));
        }
        cartItems.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product to cart');
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      isLoading(true);
      // Suppression optimiste (retire d'abord de la liste visuelle)
      cartItems.removeWhere((p) => p.id == product.id);

      final success = await _cartService.removeFromCart(product.id.toString());

      if (!success) {
        // Si échec, remet le produit dans la liste
        cartItems.add(product);
        throw Exception('Failed to remove from server');
      }

      Get.snackbar(
        'Success',
        'Product removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      // Réajouter le produit si erreur
      if (!cartItems.any((p) => p.id == product.id)) {
        cartItems.add(product);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCartItem(Product product, int newQuantity) async {
    try {
      if (newQuantity > 0) {
        final success = await _cartService.updateQuantity(product, newQuantity);
        if (success) {
          final index = cartItems.indexWhere((p) => p.id == product.id);
          if (index >= 0) {
            cartItems[index].quantity = newQuantity;
            cartItems.refresh();
          }
        }
      } else {
        await removeFromCart(product);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  Future<Map<String, dynamic>> checkStock(
    String productId,
    int quantity,
  ) async {
    try {
      // Log de début
      debugPrint('🔄 Checking stock for product $productId (qty: $quantity)');

      final stockData = await _cartService.checkStock(productId, quantity);

      // Log de réussite
      debugPrint(
        '✅ Stock check successful - Available: ${stockData['available']}, Current stock: ${stockData['current_stock']}',
      );

      return stockData;
    } catch (e, stackTrace) {
      // Log d'erreur complet dans le terminal
      debugPrint('❌ Stock check ERROR for product $productId');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: $e');
      debugPrint('Stack trace: $stackTrace');

      return {'available': false, 'current_stock': 0, 'error': e.toString()};
    }
  }

  Future<void> placeOrder() async {
    try {
      isLoading(true);

      // Vérification finale des stocks avant paiement
      for (var product in cartItems) {
        final stockCheck = await _cartService.checkStock(
          product.id.toString(),
          product.quantity,
        );

        if (!stockCheck['available']) {
          Get.snackbar(
            'Stock insuffisant',
            '${product.name} - Il ne reste que ${stockCheck['current_stock']} unité(s)',
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading(false);
          return;
        }
      }

      final response = await _cartService.placeOrder(
        phone: checkoutPhone.value,
        address: checkoutAddress.value,
        paymentMethod: paymentMethod.value,
      );

      if (response) {
        Get.off(() => PaymentSuccessScreen(totalCost: totalPrice));
        clearCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> decreaseQuantity(Product product) async {
    if (product.quantity > 1) {
      await updateCartItem(product, product.quantity - 1);
    } else {
      await removeFromCart(product);
    }
  }

  double get totalPrice => cartItems.fold(
    0,
    (sum, product) => sum + (product.price * product.quantity),
  );

  void clearCart() {
    cartItems.clear();
  }

  bool isInCart(Product product) {
    return cartItems.any((p) => p.id == product.id);
  }
}