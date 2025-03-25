import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/widgets/favorite_button.dart';
import 'package:fish_app/widgets/add_to_cart_button.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({super.key, required this.product});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => controller.setHover(true),
      onExit: (_) => controller.setHover(false),
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(
                  controller.isHovered.value ? 0.3 : 0.1,
                ),
                spreadRadius: controller.isHovered.value ? 3 : 2,
                blurRadius: controller.isHovered.value ? 10 : 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${product.price.toStringAsFixed(2)} ${product.unit}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  FavoriteButton(product: product),
                  const SizedBox(width: 6),
                  AddToCartButton(product: product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
