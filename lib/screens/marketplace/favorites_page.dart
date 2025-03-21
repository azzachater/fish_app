import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/providers/favorite_provider.dart';
import 'package:fish_app/models/product.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteItems = favoriteProvider.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Favoris"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white], // Dégradé plus visible
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body:
          favoriteItems.isEmpty
              ? _buildEmptyState()
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemCount: favoriteItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = favoriteItems[index];
                    return _buildFavoriteCard(
                      context,
                      product,
                      favoriteProvider,
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            "Aucun favori pour le moment",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    Product product,
    FavoriteProvider provider,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            product.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${product.price.toStringAsFixed(2)} ${product.unit}",
          style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade700),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => provider.toggleFavorite(product),
        ),
      ),
    );
  }
}
