import 'dart:io';
import 'package:fish_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/add_product_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter un produit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 44, 141, 238),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Image
            Obx(
              () => GestureDetector(
                onTap: () => controller.pickImage(ImageSource.gallery),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      controller.imageUrl.value.isEmpty
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ajouter une image',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(controller.imageUrl.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nom du produit
            _buildFieldWithIcon(
              icon: Icons.shopping_bag_outlined,
              child: CustomTextField(
                controller: controller.nameController,
                label: 'Nom du produit*',
                hintText: 'Ex: Canne à pêche',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 16),

            // Prix et Stock en ligne
            Row(
              children: [
                // Prix
                Expanded(
                  child: _buildFieldWithIcon(
                    icon: Icons.attach_money_outlined,
                    child: CustomTextField(
                      controller: controller.priceController,
                      label: 'Prix*',
                      hintText: '0.00',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      obscureText: false,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Stock
                Expanded(
                  child: _buildFieldWithIcon(
                    icon: Icons.inventory_outlined,
                    child: CustomTextField(
                      controller: controller.stockController,
                      label: 'Stock*',
                      hintText: 'Quantité',
                      keyboardType: TextInputType.number,
                      obscureText: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Unité
            _buildFieldWithIcon(
              icon: Icons.scale_outlined,
              child: CustomTextField(
                controller: controller.unitController,
                label: 'Unité*',
                hintText: 'Ex: pièce',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            _buildFieldWithIcon(
              icon: Icons.description_outlined,
              child: CustomTextField(
                controller: controller.descriptionController,
                label: 'Description*',
                hintText: 'Décrivez votre produit...',
                maxLines: 3,
                obscureText: false,
              ),
            ),
            const SizedBox(height: 16),

            // Catégorie
            _buildFieldWithIcon(
              icon: Icons.category_outlined,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedCategory.value,
                    items:
                        controller.categories
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => controller.selectedCategory.value = value!,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bouton Enregistrer
            Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: () async {
                          if (controller.validateForm()) {
                            final newProduct = Product(
                              id:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              name: controller.nameController.text,
                              description:
                                  controller.descriptionController.text,
                              price: double.parse(
                                controller.priceController.text,
                              ),
                              stock: int.parse(controller.stockController.text),
                              unit: controller.unitController.text,
                              image: controller.imageUrl.value,
                              category: controller.selectedCategory.value,
                            );
                            await productController.createProduct(
                              newProduct,
                              imageFile: File(
                                controller.imageUrl.value,
                              ), // Ajout du paramètre imageFile obligatoire
                            );
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'PUBLIER LE PRODUIT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWithIcon({required IconData icon, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, right: 12),
          child: Icon(icon, size: 24, color: Colors.grey.shade600),
        ),
        Expanded(child: child),
      ],
    );
  }
}
