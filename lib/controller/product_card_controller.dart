import 'package:fish_app/controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class ProductController extends GetxController {
  var products = Product.products().obs;
  var filteredProducts = <Product>[].obs;
  var isHovered = false.obs;

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
    isHovered.value = value;
  }

  void toggleFavorite(Product product) {
    product.isFavorite = !product.isFavorite;
    products.refresh(); // Met à jour la liste des produits
  }

  int get favoriteCount => products.where((p) => p.isFavorite).length;

  int get cartCount {
    final cartController = Get.find<CartController>();
    return cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
