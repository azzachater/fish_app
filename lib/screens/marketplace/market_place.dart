import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/screens/marketplace/category_chip.dart';
import 'package:fish_app/screens/marketplace/popular_product_card.dart';
import 'package:fish_app/screens/marketplace/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/product_card.dart';
import 'package:fish_app/screens/marketplace/cart_page.dart';
import 'package:fish_app/screens/marketplace/favorites_page.dart';
import 'package:fish_app/widgets/search_bar.dart';

/*class Marketplace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final CartControllerX cartController = Get.put(CartControllerX());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "🎣 Catch the Best Deals",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Get.to(() => FavoritesPage()),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Color(0xFF2597F5)),
                onPressed: () {
                  Get.to(() => CartPage()) ??
                      print("Erreur: Page introuvable !");
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Obx(() {
                  return cartController.cartItems.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartController.cartItems.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                }),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SearchBarWidget(
            hintText: 'Rechercher...',
            onChanged: productController.searchProduct,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: productController.filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: productController.filteredProducts[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () => Get.to(() => AddProductPage()),
      ),
    );
  }
}*/
class Marketplace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final CartControllerX cartController = Get.put(CartControllerX());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "🎣 Pêche Passion",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Get.to(() => FavoritesPage()),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Color(0xFF2597F5)),
                onPressed: () {
                  Get.to(() => CartPage()) ??
                      print("Erreur: Page introuvable !");
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Obx(() {
                  return cartController.cartItems.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartController.cartItems.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                }),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche
              SearchBarWidget(
                hintText: 'Rechercher du matériel...',
                onChanged: productController.searchProduct,
              ),
              const SizedBox(height: 20),

              // Catégories
              const Text(
                "Catégories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryChip(label: "Tous", isSelected: true),
                    SizedBox(width: 8),
                    CategoryChip(label: "Cannes"),
                    SizedBox(width: 8),
                    CategoryChip(label: "Moulinets"),
                    SizedBox(width: 8),
                    CategoryChip(label: "Leurres"),
                    SizedBox(width: 8),
                    CategoryChip(label: "Accessoires"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Produits populaires
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Produits populaires",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("Voir tout")),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    PopularProductCard(
                      name: "Canne Shimano",
                      price: 189.00,
                      isBestSeller: true,
                    ),
                    SizedBox(width: 16),
                    PopularProductCard(
                      name: "Moulinet Daiwa",
                      price: 249.00,
                      isBestSeller: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nouveautés
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nouveautés",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("Voir tout")),
                ],
              ),
              const SizedBox(height: 20),

              // Promotion
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Promotion Spéciale",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "15% DE RÉDUCTION",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "sur tout le matériel de pêche en eau douce",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tous les produits
              const Text(
                "Tous les produits",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productController.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailPage(product: product));
                      },
                      child: ProductCard(
                        product: productController.filteredProducts[index],
                      ),
                    );
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
