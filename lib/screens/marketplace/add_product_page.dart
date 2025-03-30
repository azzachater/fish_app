import 'package:fish_app/controller/add_product_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/widgets/custom_text_field.dart';
import 'package:fish_app/widgets/gradient_background.dart';
import 'package:fish_app/widgets/image_selector.dart';
import 'package:fish_app/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [const GradientBackground(), _buildFormContainer()],
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nouveau produit",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: "Nom du produit",
            controller: controller.nameController,
            hintText: 'Ex: Canne à pêche',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: "Prix",
            controller: controller.priceController,
            keyboardType: TextInputType.number,
            hintText: 'Ex: 19.99',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: "Description",
            controller: controller.descriptionController,
            maxLines: 3,
            hintText: 'Décrivez votre produit...',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: "Unité",
            controller: controller.unitController,
            hintText: 'Ex: pièce, kg, etc.',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          Obx(
            () => ImageSelector(
              imageUrl: controller.imageUrl.value,
              onImageSelected: () => controller.pickImage(ImageSource.gallery),
            ),
          ),
          const SizedBox(height: 30),
          SaveButton(
            onPressed: () {
              if (controller.validateForm()) {
                final newProduct = Product(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: controller.nameController.text,
                  description: controller.descriptionController.text,
                  price: double.parse(controller.priceController.text),
                  unit: controller.unitController.text,
                  image: controller.imageUrl.value,
                  category: controller.selectedCategory.value,
                  stock: '1',
                );
                productController.products.add(newProduct);
                productController.filteredProducts.refresh();
                Get.back();
                Get.snackbar(
                  "Succès",
                  "Produit ajouté avec succès!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
