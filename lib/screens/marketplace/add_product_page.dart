import 'package:fish_app/controller/add_product_controller.dart';
import 'package:fish_app/widgets/custom_text_field.dart';
import 'package:fish_app/widgets/gradient_background.dart';
import 'package:fish_app/widgets/image_selector.dart';
import 'package:fish_app/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [const GradientBackground(), _buildFormContainer()],
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 120),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add product",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: "Product Name",
            controller: controller.nameController,
            hintText: 'Enter product name',
            obscureText: false,
          ),
          CustomTextField(
            label: "Price",
            controller: controller.priceController,
            keyboardType: TextInputType.number,
            hintText: 'Enter price',
            obscureText: false,
          ),
          CustomTextField(
            label: "Description",
            controller: controller.descriptionController,
            maxLines: 3,
            hintText: 'Enter description',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          ImageSelector(
            imageUrl: controller.imageUrl,
            onImageSelected: controller.setImage,
          ),

          const SizedBox(height: 20), // Espace avant le bouton
          SaveButton(onPressed: controller.saveProduct),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
