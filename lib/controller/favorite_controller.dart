import 'package:fish_app/controller/product_card_controller.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

// Dans FavoriteController.dart
class FavoriteController extends GetxController {
  final productController = Get.find<ProductController>();
  var favorites = <Product>[].obs;

  @override
  void onReady() {
    super.onReady();
    ever(productController.favoriteIds as RxInterface<Object?>, (_) => _syncFavorites());
    _syncFavorites();
  }

  void _syncFavorites() {
    favorites.assignAll(
      productController.products.where(
        (p) => productController.isFavorite(p.id)
      ).toList()
    );
  }
}