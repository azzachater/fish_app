import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_background.dart';

class AddTipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 20),
              Text(
                "Add Tips",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CustomTextField(label: "Tip title", hintText: "Title"),
              SizedBox(height: 15),
              CustomTextField(
                label: "Tip Description",
                hintText: "Description",
                maxLines: 5,
              ),
              SizedBox(height: 30),
              CustomButton(
                text: "Save",
                onPressed: () {},
                isPrimary: true, // Added the missing isPrimary parameter
              ),
            ],
          ),
        ),
      ),
    );
  }
}