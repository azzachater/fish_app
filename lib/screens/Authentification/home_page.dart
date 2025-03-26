import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthController authController = Get.find<AuthController>(); // Utilisation correcte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Column(
                children: [
                  Text("Welcome", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text(
                    "Bienvenue sur l'application !",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Image.asset("assets/images/Authentification/welcome.png", height: 200),
              Column(
                children: [
                  CustomButton(text: "Login", onPressed: () => Get.to(() => LoginPage()), isPrimary: false),
                  const SizedBox(height: 20),
                 // CustomButton(text: "Sign up", onPressed: () => Get.to(() => SignupPage()), isPrimary: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
