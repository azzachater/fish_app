import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class FavoriteController extends GetxController {
  var favoriteItems = <Product>[].obs;

  void toggleFavorite(Product product) {
    if (favoriteItems.contains(product)) {
      favoriteItems.remove(product);
    } else {
      favoriteItems.add(product);
    }
  }
}
