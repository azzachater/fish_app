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
  var isEditMode = false.obs;
  var currentProductId = "".obs;

  // Liste des catégories disponibles
  final List<String> categories = [
    "Cannes",
    "Moulinets",
    "Leurres",
    "Accessoires",
  ];

  // Initialisation pour le mode édition
  void initializeForEdit(Product product) {
    isEditMode.value = true;
    currentProductId.value = product.id;
    nameController.text = product.name;
    priceController.text = product.price.toString();
    descriptionController.text = product.description;
    unitController.text = product.unit;
    stockController.text = product.stock.toString();
    selectedCategory.value = product.category;
    // Note: On ne charge pas imageUrl ici car c'est une URL distante
  }

  // Sélection d'image
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

  // Soumission du formulaire (création ou édition)
  Future<void> submitProduct() async {
    if (!validateForm()) return;

    try {
      isLoading(true);

      final product = Product(
        id: isEditMode.value ? currentProductId.value : '',
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        unit: unitController.text,
        stock: int.parse(stockController.text),
        image: '', // Sera remplacé par l'URL du serveur
        category: selectedCategory.value,
        userId: '', // Remplacé par le vrai userId dans le ProductController
      );

      File? imageFile;
      if (imageUrl.value.isNotEmpty) {
        imageFile = File(imageUrl.value);
      }

      final productController = Get.find<ProductController>();

      if (isEditMode.value) {
        await productController.updateProduct(
          product,
          imageFile: imageFile,
        );
      } else {
        // Vérification obligatoire de l'image pour la création
        if (imageFile == null) {
          throw Exception('Veuillez sélectionner une image');
        }
        await productController.createProduct(
          product,
          imageFile: imageFile!,
        );
      }

      resetForm();
      Get.back();
      Get.snackbar(
        'Succès',
        isEditMode.value ? 'Produit mis à jour' : 'Produit créé avec succès',
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
        stockController.text.isEmpty) {
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
    isEditMode.value = false;
    currentProductId.value = "";
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