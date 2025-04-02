import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  // Contrôleurs pour les champs du formulaire
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  // États observables
  var imageUrl = "".obs;
  var selectedCategory = "Cannes".obs;
  var isLoading = false.obs;
  var isImageUploading = false.obs;

  // Liste des catégories disponibles
  final List<String> categories = [
    "Cannes",
    "Moulinets",
    "Leurres",
    "Accessoires",
  ];

  // Méthode pour sélectionner une image
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageUploading(true);
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        imageUrl.value = pickedFile.path;
      }
    } catch (e) {
      _showErrorSnackbar(
        "Erreur d'image",
        "Impossible de sélectionner l'image: ${e.toString()}",
      );
    } finally {
      isImageUploading(false);
    }
  }

  // Validation du formulaire
  bool validateForm() {
    // Vérification des champs vides
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        unitController.text.isEmpty ||
        stockController.text.isEmpty ||
        imageUrl.value.isEmpty) {
      _showErrorSnackbar(
        "Formulaire incomplet",
        "Veuillez remplir tous les champs obligatoires",
      );
      return false;
    }

    // Validation du prix
    if (double.tryParse(priceController.text) == null) {
      _showErrorSnackbar(
        "Prix invalide",
        "Veuillez entrer un nombre valide pour le prix",
      );
      return false;
    }

    // Validation du stock
    if (int.tryParse(stockController.text) == null) {
      _showErrorSnackbar(
        "Stock invalide",
        "Veuillez entrer un nombre entier pour le stock",
      );
      return false;
    }

    return true;
  }

  // Réinitialisation du formulaire
  void resetForm() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    unitController.clear();
    stockController.clear();
    imageUrl.value = "";
    selectedCategory.value = "Cannes";
  }

  // Affichage des erreurs
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    // Nettoyage des contrôleurs
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    unitController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
