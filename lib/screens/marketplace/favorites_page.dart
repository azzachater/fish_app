import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/providers/favorite_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Favoris")),
      body: ListView.builder(
        itemCount: favoriteProvider.favoriteItems.length,
        itemBuilder: (context, index) {
          final product = favoriteProvider.favoriteItems[index];
          return ListTile(
            leading: Image.asset(product.imageUrl, width: 50),
            title: Text(product.name),
            subtitle: Text("${product.price} ${product.unit}"),
          );
        },
      ),
    );
  }
}
