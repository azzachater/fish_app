import 'package:fish_app/controller/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class FavoriteButton extends StatelessWidget {
  final Product product;

  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController =
        Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = favoriteController.favoriteItems.contains(product);
      return IconButton(
        onPressed: () {
          favoriteController.toggleFavorite(product);
        },
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
        ),
      );
    });
  }
}
