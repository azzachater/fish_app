import 'package:fish_app/controller/product_card_controller.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class FavoriteController extends GetxController {
  var favoriteItems = <Product>[].obs;

  // Ajouter ou retirer un produit des favoris
  void toggleFavorite(Product product) {
    final existingIndex = favoriteItems.indexWhere((p) => p.id == product.id);

    if (existingIndex >= 0) {
      // Retirer des favoris
      favoriteItems.removeAt(existingIndex);
    } else {
      // Ajouter aux favoris
      favoriteItems.add(product.copyWith(isFavorite: true));
    }

    // Mettre à jour l'état du produit dans le ProductController
    final productController = Get.find<ProductController>();
    productController.toggleFavorite(product);
  }
}
