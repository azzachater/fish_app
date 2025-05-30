import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();
    final userController = Get.find<UserController>();
    final currentUser = userController.currentUser.value;

    // Vérifie si l'utilisateur actuel est le propriétaire du produit
    final isOwner =
        currentUser != null && currentUser.id.toString() == product.userId;

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
                        image: _getImageProvider(product.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:
                        product.image.isEmpty
                            ? Icon(Icons.photo, size: 50, color: Colors.grey)
                            : null,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${product.price} ${product.unit}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.stock > 0) ...[
                        SizedBox(height: 4),
                        Text(
                          'En stock: ${product.stock}',
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      ] else ...[
                        SizedBox(height: 4),
                        Text(
                          'Rupture de stock',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Bouton Favori
            Positioned(
              top: 12,
              left: 12,
              child: Obx(() {
                final isFav = productController.isFavorite(product.id);
                return GestureDetector(
                  onTap: () {
                    productController.toggleFavorite(product.id);
                    // Mettre à jour localement l'état du produit
                    product.isFavorite = !isFav;
                  },
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

            // Bouton Panier (seulement si en stock)
            if (product.stock > 0)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    try {
                      final stockCheck = await cartController.checkStock(
                        product.id.toString(),
                        1, // quantité à ajouter
                      );

                      if (stockCheck['available']) {
                        await cartController.addToCart(product);
                      } else {
                        Get.snackbar(
                          'Stock insuffisant',
                          'Il ne reste que ${stockCheck['current_stock']} unités',
                        );
                      }
                    } catch (e) {
                      Get.snackbar('Erreur', 'Impossible de vérifier le stock');
                    }
                  },
                ),
              ),

            // Menu des trois points (seulement pour le propriétaire)
            if (isOwner)
              Positioned(
                top: 12,
                right: 12,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Get.to(
                        () => AddProductPage(
                          productToEdit: product,
                        ), // Passez le produit à éditer
                        transition: Transition.rightToLeft,
                      );
                    } else if (value == 'delete') {
                      final confirm = await Get.dialog(
                        AlertDialog(
                          title: const Text('Confirmer la suppression'),
                          content: Text(
                            'Supprimer "${product.name}" définitivement?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Get.back(result: true),
                              child: const Text(
                                'Supprimer',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await productController.deleteProduct(product.id);
                          Get.snackbar(
                            'Succès',
                            'Produit supprimé',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Erreur',
                            'Échec de la suppression: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: AppTheme.primaryColor),
                              SizedBox(width: 8),
                              Text('Modifier'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Supprimer'),
                            ],
                          ),
                        ),
                      ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return NetworkImage('http://192.168.1.85:8000/storage/$imagePath');
    }
  }
}
