import 'dart:io';

import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onImageSelected;

  const ImageSelector({
    Key? key,
    required this.imageUrl,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Image du produit",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onImageSelected,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child:
                imageUrl.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cliquez pour ajouter une image',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imageUrl),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}
