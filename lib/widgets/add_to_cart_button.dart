import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  AddToCartButton({super.key, required this.product});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isAdded = cartController.isInCart(product);

      return IconButton(
        onPressed: () {
          isAdded
              ? cartController.removeFromCart(product)
              : cartController.addToCart(product);
        },
        icon: Icon(
          Icons.shopping_cart,
          color: isAdded ? AppTheme.primaryColor : Colors.grey,
        ),
      );
    });
  }
}