import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  AddToCartButton({super.key, required this.product});

  final AddCartController cartController = Get.find<AddCartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isAdded = cartController.isInCart(product);

      return IconButton(
        onPressed: () {
          isAdded
              ? cartController.removeProduct(product)
              : cartController.addProduct(product);
        },
        icon: Icon(
          Icons.shopping_cart,
          color: isAdded ? Colors.blue : Colors.grey,
        ),
      );
    });
  }
}
