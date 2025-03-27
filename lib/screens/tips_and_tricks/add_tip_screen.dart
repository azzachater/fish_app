import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/tip_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/theme.dart';
import '../../controllers/tip_controller.dart'; // Import TipController

class AddTipScreen extends StatelessWidget {
  AddTipScreen({super.key, required this.onAdd});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Callback function to add a new tip
  final Function(Tip) onAdd;

  @override
  Widget build(BuildContext context) {
    // Get instance of TipController
    final TipController controller = Get.find<TipController>();

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Space above the form
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
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
                      label: "Title",
                      controller: titleController, hintText: '', obscureText: false
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Description",
                      maxLines: 5,
                      controller: descriptionController, hintText: '', obscureText: false
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () {
                          // Retrieve values
                          String title = titleController.text.trim();
                          String description = descriptionController.text.trim();

                          if (title.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("All fields are required!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Create a new Tip
                          Tip newTip = Tip(title: title, description: description);

                          // Add the new tip using GetX controller
                          controller.addTip(newTip);

                          // Go back to the tips page
                          Navigator.pop(context);
                        },
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
