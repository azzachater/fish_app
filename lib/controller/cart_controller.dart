import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  void addProduct(Product product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      cartItems[index].quantity += 1;
      cartItems.refresh(); // Mettre à jour l'UI
    } else {
      product.quantity = 1;
      cartItems.add(product);
    }
    print("Produit ajouté : ${product.name}, Quantité : ${product.quantity}");
  }

  void decreaseQuantity(Product product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems.removeAt(index);
      }
      cartItems.refresh(); // Mettre à jour l'UI
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
