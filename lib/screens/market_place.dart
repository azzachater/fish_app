import 'package:fish_app/screens/marketplace/add_product_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/widgets/product_card.dart';
import 'package:fish_app/screens/marketplace/cart_page.dart';
import 'package:fish_app/screens/marketplace/favorites_page.dart';
import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/widgets/search_bar.dart';

class Marketplace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Product.products();
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Color.fromARGB(255, 37, 151, 245),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
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
              print('Recherche: $value');
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            // Utilisation correcte d'Expanded ici
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () {
          //ouvrir la formulaire
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
      ),
    );
  }
}
