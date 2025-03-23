import 'package:fish_app/controller/add_product_controller.dart';
import 'package:fish_app/widgets/custom_text_field.dart';
import 'package:fish_app/widgets/gradient_background.dart';
import 'package:fish_app/widgets/image_selector.dart';
import 'package:fish_app/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  final AddProductController controller = Get.put(
    AddProductController(),
  ); // Injection du controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [GradientBackground(), _buildFormContainer()]),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      margin: EdgeInsets.only(top: 120),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add product",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomTextField(
            label: "Product Name",
            controller: controller.nameController,
            hintText: 'name',
            obscureText: false,
          ),
          CustomTextField(
            label: "Price",
            controller: controller.priceController,
            keyboardType: TextInputType.number,
            hintText: 'price',
            obscureText: false,
          ),
          CustomTextField(
            label: "Description",
            controller: controller.descriptionController,
            maxLines: 3,
            hintText: 'description',
            obscureText: false,
          ),
          SizedBox(height: 15),
          Obx(
            () => ImageSelector(
              imageUrl: controller.imageUrl.value,
              onImageSelected: (url) {
                controller.setImage(url);
              },
            ),
          ),
          SizedBox(height: 15),
          SaveButton(onPressed: controller.saveProduct),
        ],
      ),
    );
  }
}
