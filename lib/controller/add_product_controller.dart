import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  var imageUrl = "".obs;
  var selectedCategory = "Cannes".obs;
  final List<String> categories = [
    "Cannes",
    "Moulinets",
    "Leurres",
    "Accessoires",
  ];

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        imageUrl.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de sélectionner l'image",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool validateForm() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        unitController.text.isEmpty ||
        imageUrl.value.isEmpty) {
      Get.snackbar(
        "Erreur",
        "Veuillez remplir tous les champs",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (double.tryParse(priceController.text) == null) {
      Get.snackbar(
        "Erreur",
        "Prix invalide",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    unitController.dispose();
    super.onClose();
  }
}
