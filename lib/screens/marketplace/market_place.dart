import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/screens/marketplace/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/category_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:fish_app/screens/marketplace/category_chip.dart';
import 'package:fish_app/screens/marketplace/favorites_page.dart';
import 'package:fish_app/screens/marketplace/product_card.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/search_bar.dart';

class Marketplace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final CategoryController categoryController = Get.put(CategoryController());

    // Rafraîchir les produits au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.fetchProducts();
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          "🎣 Catch the best deal",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightPrimary, // Texte clair
          ),
        ),
        actions: [
          IconButton(
            icon: Badge(
              child: Icon(Icons.favorite, color: AppTheme.lightPrimary),
              isLabelVisible: productController.favoriteCount > 0,
              label: Text(
                productController.favoriteCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
            onPressed: () => Get.to(() => FavoritesPage()),
          ),
          IconButton(
            icon: Badge(
              child: Icon(Icons.shopping_cart, color: AppTheme.lightPrimary),
              isLabelVisible: productController.cartCount > 0,
              label: Text(
                productController.cartCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
                  Colors
                      .green, // Ou AppTheme.darkPrimary si tu veux garder l’uniformité
            ),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche améliorée
              SearchBarWidget(
                hintText: 'Rechercher du matériel...',
                onChanged: productController.searchProduct,
              ),
              const SizedBox(height: 20),

              // Titre Catégories avec style moderne
              Text(
                "Catégories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),

              // Catégories horizontales avec effet de sélection
              Obx(
                () => SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categories[index];
                      return CategoryChip(
                        label: category.name,
                        isSelected: category.isSelected,
                        onTap: () => categoryController.selectCategory(index),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Affichage des produits avec grille moderne
              Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selectedCategory =
                    categoryController.categories
                        .firstWhere((c) => c.isSelected)
                        .name;

                final products =
                    selectedCategory == "Tous"
                        ? productController.filteredProducts
                        : productController.filteredProducts
                            .where(
                              (product) => product.category == selectedCategory,
                            )
                            .toList();

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Aucun produit trouvé",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () => Get.to(() => AddProductPage()),
      ),
    );
  }
}
