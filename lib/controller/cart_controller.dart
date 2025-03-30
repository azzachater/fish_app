import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class CartController extends GetxController {
  // Liste observable des articles du panier
  var cartItems = <Product>[].obs;

  // Ajouter un produit au panier ou incrémenter sa quantité
  void addProduct(Product product) {
    final index = cartItems.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(
        Product(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          unit: product.unit,
          stock: product.stock,
          image: product.image,
          quantity: 1,
          category: product.category,
          // Copiez les autres propriétés nécessaires
        ),
      );
    }
    cartItems.refresh(); // Force la mise à jour de l'UI
  }

  // Diminuer la quantité ou supprimer le produit
  void decreaseQuantity(Product product) {
    final index = cartItems.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  // Calcul du sous-total
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Nouvelle méthode pour vider le panier après paiement
  void clearCart() {
    cartItems.clear();
  }
}
