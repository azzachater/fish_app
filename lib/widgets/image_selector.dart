import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final String? imageUrl;
  final Function(String) onImageSelected;

  const ImageSelector({
    Key? key,
    required this.imageUrl,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            // Simule une sélection d'image (tu peux remplacer par une vraie fonctionnalité)
            onImageSelected("https://via.placeholder.com/100");
          },
          child: Icon(Icons.add_a_photo),
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }
}
