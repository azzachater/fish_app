import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/widgets/favorite_button.dart';
import 'package:fish_app/widgets/add_to_cart_button.dart';
import 'package:get/get.dart';

/*class ProductCard extends StatelessWidget {
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
                  product.image,
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
*/
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartControllerX cartController = Get.find<CartControllerX>();

    return GestureDetector(
      onTap: () {
        // Action lorsqu'on clique sur le produit
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge BEST SELLER
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product
                    .isPopular) // Ajoutez cette propriété à votre modèle Product
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "BEST SELLER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      cartController.addProduct(product);
                    },
                  ),
                ),
              ],
            ),
            // Détails du produit
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product.price} €",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Note: Vous pouvez ajouter ici d'autres détails comme les étoiles de notation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
