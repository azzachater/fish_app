import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class FavoriteButton extends StatelessWidget {
  final Product product;

  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Obx(() {
      final isFavorite = productController.isFavorite(product.id);
      return IconButton(
        onPressed: () {
          productController.toggleFavorite(product.id);
          // Mise à jour immédiate de l'état visuel
          product.isFavorite = !isFavorite; 
        },
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: 24,
        ),
      );
    });
  }
}