import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../constants/theme.dart';
import '../../controllers/auth_controller.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.find<AuthController>(); // Utilisation correcte de GetX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(), // Utilisation de GetX pour revenir en arrière
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
              const Text("Login", style: AppTheme.titleStyle),
              const SizedBox(height: 10),
              const Text("Login to your account", style: AppTheme.subtitleStyle),
              const SizedBox(height: 30),
              const CustomTextField(label: "Email"),
              const CustomTextField(label: "Password", obscureText: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Login",
                onPressed: () {
                  authController.login(); // Appel du contrôleur pour gérer l'authentification
                },
                isPrimary: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () => Get.to(() => SignupPage()), // Utilisation de GetX pour la navigation
                    child: const Text(" Sign up", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 200,
                child: Image.asset("assets/images/Authentification/background.png", fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
