import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartControllerX cartController = Get.find<CartControllerX>();

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
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Image.asset(product.image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),

            // Contenu détaillé
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Canne à pêche haut de gamme pour une expérience de pêche inégalée. "
                    "Conçue avec des matériaux légers et résistants pour une performance optimale.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Le design ergonomique et léger vous permet de pêcher toute la journée "
                    "sans fatigue. La sensibilité accrue vous aide à détecter les touches "
                    "les plus subtiles.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      // Action "Lire plus"
                    },
                    child: const Text(
                      "Lire plus...",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Prix et bouton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product.price} €",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cartController.addProduct(product);
                          Get.snackbar(
                            "Ajouté au panier",
                            "${product.name} a été ajouté à votre panier",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Ajouter au panier",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
}
