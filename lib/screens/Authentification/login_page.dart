import 'package:fish_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../constants/theme.dart';
import '../../controllers/auth_controller.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  void validateAndLogin() {
    // Reset previous errors
    emailError.value = '';
    passwordError.value = '';

    bool isValid = true;

    // Validate Email
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Validate Password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      isValid = false;
    }

    // If valid, proceed with login
    if (isValid) {
      authController.login(emailController.text, passwordController.text);
    }
  }

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
              const Text("Login", style: AppTheme.titleStyle),
              const SizedBox(height: 10),
              const Text(
                "Login to your account",
                style: AppTheme.subtitleStyle,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Email",
                hintText: "Enter your email",
                controller: emailController,
                obscureText: false,
              ),
              // Affichage de l'erreur sous le champ email
              Obx(
                () =>
                    emailError.value.isNotEmpty
                        ? Text(
                          emailError.value,
                          style: TextStyle(color: Colors.red),
                        )
                        : Container(),
              ),
              CustomTextField(
                label: "Password",
                hintText: "Enter your password",
                controller: passwordController,
                obscureText: true,
              ),
              // Affichage de l'erreur sous le champ password
              Obx(
                () =>
                    passwordError.value.isNotEmpty
                        ? Text(
                          passwordError.value,
                          style: TextStyle(color: Colors.red),
                        )
                        : Container(),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Login",
                onPressed: validateAndLogin,
                isPrimary: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () => Get.to(() => SignupPage()),
                    child: const Text(
                      " Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 200,
                child: Image.asset(
                  "assets/images/Authentification/background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
