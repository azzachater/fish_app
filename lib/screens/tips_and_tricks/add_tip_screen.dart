import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/theme.dart';

class AddTipScreen extends StatelessWidget {
  AddTipScreen({Key? key}) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Tips',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Tip Title",
                    hintText: "Enter Title",
                    controller: titleController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    label: "Tip Description",
                    hintText: "Enter Description",
                    maxLines: 5,
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Save",
                      onPressed: () {
                        // Récupération des valeurs
                        String title = titleController.text.trim();
                        String description = descriptionController.text.trim();

                        if (title.isEmpty || description.isEmpty) {
                          // Afficher une alerte si les champs sont vides
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("All fields are required!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Logique pour sauvegarder les données
                      },
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}