import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    return GestureDetector(
      onTap: () => Get.toNamed('/product', arguments: product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image:
                            product.image.startsWith('http')
                                ? NetworkImage(product.image)
                                : AssetImage(product.image) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${product.price} ${product.unit}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Nouveau Bouton Favori plus visible
            // Dans le Positioned pour l'icône favori
            Positioned(
              top: 12,
              left: 12,
              child: Obx(() {
                final isFav = productController.isFavorite(product.id);
                return GestureDetector(
                  onTap: () => productController.toggleFavorite(product.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
            // Bouton Panier
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.blue),
                onPressed: () {
                  cartController.addProduct(product);
                  Get.snackbar(
                    'Ajouté au panier',
                    '${product.name} a été ajouté à votre panier',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
