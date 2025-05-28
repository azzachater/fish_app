import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final ProductController productController = Get.find<ProductController>();
    final isFavorite = productController.isFavorite(product.id).obs;
    final isInCart =
        cartController.cartItems.any((item) => item.id == product.id).obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                isFavorite.value ? Icons.favorite : Icons.favorite_border,
                color: isFavorite.value ? Colors.red : Colors.black,
                size: 28,
              ),
              onPressed: () {
                isFavorite.toggle();
                productController.toggleFavorite(product.id);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec placeholder
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey.shade100,
                child:
                    product.image.startsWith('http')
                        ? Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                        )
                        : Image.asset(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                        ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et catégorie
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description avec expansion
                  ExpansionTile(
                    title: const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    initiallyExpanded: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          product.description.isNotEmpty
                              ? product.description
                              : "Aucune description disponible",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Spécifications techniques (simulées)
                  ..._generateProductSpecifications(product),
                  const SizedBox(height: 30),

                  // Prix et bouton d'ajout - CORRECTION DU OVERFLOW ICI
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen = constraints.maxWidth < 350;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${product.price} ${product.unit}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Flexible(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      isInCart.value
                                          ? null
                                          : () {
                                            cartController.addToCart(product);
                                            isInCart.value = true;
                                            Get.snackbar(
                                              "Ajouté au panier",
                                              "${product.name} a été ajouté à votre panier",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            );
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isInCart.value
                                            ? Colors.grey.shade300
                                            : AppTheme.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 12 : 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  icon: Icon(
                                    isInCart.value
                                        ? Icons.check
                                        : Icons.add_shopping_cart,
                                    color:
                                        isInCart.value
                                            ? Colors.grey
                                            : Colors.white,
                                    size: isSmallScreen ? 18 : 24,
                                  ),
                                  label: Text(
                                    isInCart.value
                                        ? "Déjà au panier"
                                        : "Ajouter",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isInCart.value
                                              ? Colors.grey
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateProductSpecifications(Product product) {
    final specs = <Widget>[];

    // Spécifications basées sur la catégorie
    if (product.category.toLowerCase().contains('cann')) {
      specs.addAll([
        _buildSpecificationTile("Longueur", "2.10 m"),
        _buildSpecificationTile("Poids", "350g"),
        _buildSpecificationTile("Action", "Moyenne"),
      ]);
    } else if (product.category.toLowerCase().contains('moulinet')) {
      specs.addAll([
        _buildSpecificationTile("Ratio", "5.2:1"),
        _buildSpecificationTile("Roulements", "4+1"),
        _buildSpecificationTile("Poids", "280g"),
      ]);
    } else if (product.category.toLowerCase().contains('leurr')) {
      specs.addAll([
        _buildSpecificationTile("Type", "Crevette"),
        _buildSpecificationTile("Profondeur", "1-3m"),
        _buildSpecificationTile("Poids", "15g"),
      ]);
    } else {
      // Spécifications par défaut basées sur le nom
      if (product.name.toLowerCase().contains('alumini')) {
        specs.add(_buildSpecificationTile("Matériau", "Aluminium"));
      }
      if (product.name.toLowerCase().contains('carbon')) {
        specs.add(_buildSpecificationTile("Matériau", "Fibre de carbone"));
      }

      // Ajoutez d'autres règles de détection ici...
    }

    // Toujours ajouter le prix comme spécification
    specs.add(
      _buildSpecificationTile("Prix", "${product.price} ${product.unit}"),
    );

    return specs;
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Image non disponible',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
