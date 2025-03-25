import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/product_card.dart';
import 'package:fish_app/screens/marketplace/cart_page.dart';
import 'package:fish_app/screens/marketplace/favorites_page.dart';
import 'package:fish_app/widgets/search_bar.dart';

class Marketplace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "🎣 Catch the Best Deals",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Texte en gras
          ),
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
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Color.fromARGB(255, 37, 151, 245),
            ),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SearchBarWidget(
            hintText: 'search',
            onChanged: (value) {
              productController.searchProduct(value);
            },
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

class ProductController {
  get filteredProducts => null;

  void searchProduct(String value) {}
}
