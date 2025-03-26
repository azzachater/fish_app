import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class CartControllerX extends GetxController {
  var cartItems = <Product>[].obs;

  void addProduct(Product product) {
    var existingProduct = cartItems.firstWhereOrNull((p) => p.id == product.id);
    if (existingProduct != null) {
      existingProduct.quantity++; // Augmenter la quantité si déjà ajouté
    } else {
      cartItems.add(product);
    }
  }

  void removeProduct(Product product) {
    var existingProduct = cartItems.firstWhereOrNull((p) => p.id == product.id);
    if (existingProduct != null && existingProduct.quantity > 1) {
      existingProduct.quantity--; // Réduire la quantité si plus d'un
    } else {
      cartItems.removeWhere((p) => p.id == product.id); // Supprimer si 1 seul
    }
  }

  bool isInCart(Product product) {
    return cartItems.any((p) => p.id == product.id);
  }
}
