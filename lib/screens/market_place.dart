import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/product_card.dart';
import 'package:fish_app/screens/marketplace/cart_page.dart';
import 'package:fish_app/screens/marketplace/favorites_page.dart';
import 'package:fish_app/widgets/search_bar.dart';

class Marketplace extends StatelessWidget {
  const Marketplace({super.key});

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
}
