import 'package:flutter/material.dart';
import '../../models/tip_model.dart'; // Import Tip model
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/theme.dart'; // Ensure theme is correctly imported

class EditTipScreen extends StatefulWidget {
  final Tip? tip;
  final Function(Tip) onUpdate; // Add the update callback

  const EditTipScreen({super.key, this.tip, required this.onUpdate});

  @override
  EditTipScreenState createState() => EditTipScreenState();
}

class EditTipScreenState extends State<EditTipScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the fields if the tip exists
    _titleController = TextEditingController(text: widget.tip?.title ?? '');
    _descriptionController = TextEditingController(text: widget.tip?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Use the primary color from theme
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
                      controller: _titleController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Description",
                      maxLines: 5,
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Save Changes",
                        onPressed: () {
                          String title = _titleController.text.trim();
                          String description = _descriptionController.text.trim();

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
                          Tip updatedTip = Tip(
                            title: title,
                            description: description,
                          );

                          // Call onUpdate with the updated tip
                          widget.onUpdate(updatedTip);

                          Navigator.pop(context); // Go back to the previous page

                          // Show success message
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
