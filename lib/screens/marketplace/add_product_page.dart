import 'package:fish_app/widgets/custom_text_field.dart';
import 'package:fish_app/widgets/gradient_background.dart';
import 'package:fish_app/widgets/image_selector.dart';
import 'package:fish_app/widgets/save_button.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  //controlleur bech yrecuperi l valeret mtaa champs de saisie
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  //bech nestokiw fiha l'image
  String? _imageUrl;

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
            controller: _nameController,
            hintText: 'name',
            obscureText: false,
          ),
          CustomTextField(
            label: "Price",
            controller: _priceController,
            keyboardType: TextInputType.number,
            hintText: 'price',
            obscureText: false,
          ),
          CustomTextField(
            label: "Description",
            controller: _descriptionController,
            maxLines: 3,
            hintText: 'description',
            obscureText: false,
          ),
          SizedBox(height: 15),
          ImageSelector(
            imageUrl: _imageUrl,
            onImageSelected: (url) {
              setState(() => _imageUrl = url);
            },
          ),
          SizedBox(height: 15),
          SaveButton(onPressed: _saveProduct),
        ],
      ),
    );
  }

  void _saveProduct() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: const Color.fromARGB(255, 60, 94, 246),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Product saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
