/*import 'package:fish_app/service/api_cart_service.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class CartControllerX extends GetxController {
  final CartService _cartService = CartService();
  var cartItems = <Product>[].obs;
  var isLoading = false.obs;

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

  Future<void> addProduct(Product product) async {
    try {
      final success = await _cartService.addToCart(product, 1);
      if (success) {
        final existingIndex = cartItems.indexWhere((p) => p.id == product.id);
        if (existingIndex >= 0) {
          cartItems[existingIndex].quantity++;
          cartItems.refresh();
        } else {
          product.quantity = 1;
          cartItems.add(product);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product to cart');
    }
  }

  Future<void> decreaseQuantity(Product product) async {
    if (product.quantity > 1) {
      await updateQuantity(product, product.quantity - 1);
    } else {
      await removeProduct(product);
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    try {
      final success = await _cartService.updateQuantity(product, newQuantity);
      if (success) {
        final index = cartItems.indexWhere((p) => p.id == product.id);
        if (index >= 0) {
          cartItems[index].quantity = newQuantity;
          cartItems.refresh();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      final success = await _cartService.removeFromCart(product);
      if (success) {
        cartItems.removeWhere((p) => p.id == product.id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove product from cart');
    }
  }

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  bool isInCart(Product product) {
    return cartItems.any((p) => p.id == product.id);
  }
}
*/