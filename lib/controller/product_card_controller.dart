import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/controller/cart_controller.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    products.assignAll(Product.sampleProducts());
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
                  product.name.toLowerCase().contains(query.toLowerCase()) ||
                  product.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
  }

  void toggleFavorite(String productId) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      products[index] = products[index].copyWith(
        isFavorite: !products[index].isFavorite,
      );
      products.refresh();
      filteredProducts.refresh();
    }
  }

  int get favoriteCount => products.where((p) => p.isFavorite).length;

  int get cartCount {
    final cartController = Get.find<CartController>();
    return cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
