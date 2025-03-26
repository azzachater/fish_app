import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/tip_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/theme.dart';
import '../../controllers/tip_controller.dart'; // Import TipController

class EditTipScreen extends StatelessWidget {
  final Tip? tip;
  final Function(Tip) onUpdate; // Update callback

  const EditTipScreen({super.key, this.tip, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    // Get instance of TipController
    final TipController controller = Get.find<TipController>();

    // Pre-fill the text fields
    final TextEditingController titleController = TextEditingController(text: tip?.title ?? '');
    final TextEditingController descriptionController = TextEditingController(text: tip?.description ?? '');

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
                      'Edit Tip',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Title",
                      controller: titleController, hintText: '', obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Description",
                      maxLines: 5,
                      controller: descriptionController, hintText: '', obscureText: false,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Save Changes",
                        onPressed: () {
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

                          // Create a new Tip with updated values
                          Tip updatedTip = Tip(title: title, description: description);

                          // Update the tip using GetX controller
                          controller.updateTip(controller.tips.indexOf(tip!), updatedTip);

                          // Close the screen and go back
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tip updated successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
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
