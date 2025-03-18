import 'package:fish_app/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void addProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
}
