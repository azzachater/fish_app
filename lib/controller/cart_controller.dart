//au lieu de cart provider
import 'package:fish_app/models/product.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addProduct(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      cartItems.add(
        product.copyWith(quantity: 1),
      ); // Assure que la quantité initiale est 1
    }
  }

  void removeProduct(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity - 1,
        );
      } else {
        cartItems.removeAt(index);
      }
    }
  }
}
