import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var imageUrl = "".obs;

  get imageFile => null; // Observable pour l'image

  void setImage(String imagePath) {
    imageUrl.value = imagePath;
  }

  void saveProduct() {
    print("Product Name: ${nameController.text}");
    print("Price: ${priceController.text}");
    print("Description: ${descriptionController.text}");
    print("Image: ${imageUrl.value}");
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }

    Get.snackbar(
      "Success",
      "Product saved successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
