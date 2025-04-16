import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        return progress == null
            ? child
            : Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image);
      },
    );
  }
}
