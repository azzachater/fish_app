import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class ProductController extends GetxController {
  var products = Product.products().obs;
  var filteredProducts = <Product>[].obs;
  var isHovered = false.obs; // Utilisation correcte d'un état réactif

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(products);
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void setHover(bool value) {
    isHovered.value = value; // Met à jour l'état de survol
  }
}
