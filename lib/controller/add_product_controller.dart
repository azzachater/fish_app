import 'dart:io';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/models/product.dart';
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

  /*Future<void> submitProduct() async {
    if (!validateForm()) return;

    try {
      isLoading(true);

      final product = Product(
        id: '', // L'ID sera généré par le backend
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        unit: unitController.text,
        stock: int.parse(stockController.text),
        image: '', // L'image sera gérée par le multipart
        category: selectedCategory.value,
      );

      File? imageFile;
      if (imageUrl.value.isNotEmpty) {
        imageFile = File(imageUrl.value);
      }

      await Get.find<ProductController>().createProduct(
        product,
        imageFile: imageFile,
      );

      resetForm();
      Get.back();
      Get.snackbar('Succès', 'Produit ajouté avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }

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
  }*/
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
        Get.snackbar(
          'Succès',
          'Image sélectionnée',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner l\'image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isImageUploading(false);
    }
  }

  Future<void> submitProduct() async {
    if (!validateForm()) return;

    try {
      isLoading(true);

      // Vérification obligatoire de l'image
      if (imageUrl.value.isEmpty) {
        throw Exception('Veuillez sélectionner une image');
      }

      final imageFile = File(imageUrl.value);

      final product = Product(
        id: '',
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        unit: unitController.text,
        stock: int.parse(stockController.text),
        image: '', // Sera remplacé par l'URL du serveur
        category: selectedCategory.value,
      );

      await Get.find<ProductController>().createProduct(
        product,
        imageFile: imageFile,
      );

      resetForm();
      Get.back();
      Get.snackbar(
        'Succès',
        'Produit créé avec succès',
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
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
