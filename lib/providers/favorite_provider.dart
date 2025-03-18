import 'package:flutter/material.dart';
import 'package:fish_app/models/product.dart';

class FavoriteProvider with ChangeNotifier {
  //liste privé
  final List<Product> _favoriteItems = [];
  //getter
  List<Product> get favoriteItems => _favoriteItems;
  //pour ajouter ou supprimer un produir des favoris (si deja liker , remove sinon add)
  void toggleFavorite(Product product) {
    if (_favoriteItems.contains(product)) {
      _favoriteItems.remove(product);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }
}
