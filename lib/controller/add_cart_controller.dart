import 'package:fish_app/models/product.dart';
import 'package:get/get.dart';

class AddCartController extends GetxController {
  var cartItems = <Product>[].obs;
  void addProduct(Product product) {
    cartItems.add(product);
  }

  void removeProduct(Product product) {
    cartItems.remove(product);
  }

  bool isInCart(Product product) {
    return cartItems.contains(product);
  }
}
