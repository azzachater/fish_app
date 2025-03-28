import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ImageSelector extends StatelessWidget {
  final RxString imageUrl;
  final Function(String) onImageSelected;

  const ImageSelector({
    super.key,
    required this.imageUrl,
    required this.onImageSelected,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onImageSelected(pickedFile.path); // Met à jour l'URL de l'image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () =>
              imageUrl.value.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        imageUrl.value.startsWith('http')
                            ? Image.network(
                              imageUrl.value,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                            )
                            : Image.file(
                              File(imageUrl.value),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                  )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: _pickImage,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add_a_photo),
        ),
      ],
    );
  }
}
