import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/providers/favorite_provider.dart';
import 'package:fish_app/models/product.dart';

class FavoriteButton extends StatelessWidget {
  final Product product;
  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //consumer permer d'ecouter les changements dans Favoriteprovider et de mmetre ajour auto
    return Consumer<FavoriteProvider>(
      //fonction qui reconstruit l UI lorsque favoriteProvider change
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.favoriteItems.contains(product);
        return IconButton(
          onPressed: () {
            favoriteProvider.toggleFavorite(product);
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.blue : Colors.grey,
          ),
        );
      },
    );
  }
}
