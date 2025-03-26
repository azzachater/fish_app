import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final AuthController authController = Get.find<AuthController>(); // Utilisation correcte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text("Sign up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const CustomTextField(label: "Username"),
              const CustomTextField(label: "Email"),
              const CustomTextField(label: "Password", obscureText: true),
              const CustomTextField(label: "Confirm Password", obscureText: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Sign up",
                onPressed: authController.signup, // Appel direct du controller
                isPrimary: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () => Get.to(() => LoginPage()),
                    child: const Text(" Login", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
