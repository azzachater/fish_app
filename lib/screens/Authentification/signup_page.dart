import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final AuthController authController = Get.find<AuthController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxString usernameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  void validateAndSignup() {
    // Reset previous errors
    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    bool isValid = true;

    // Validate Username
    if (usernameController.text.isEmpty) {
      usernameError.value = 'Username cannot be empty';
      isValid = false;
    }

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

    // Validate Confirm Password
    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    // If valid, proceed with signup
    if (isValid) {
      authController.signup(
        usernameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      );
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
              const Text(
                "Sign up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Username",
                controller: usernameController,
                hintText: 'enter your Username',
                obscureText: false,
              ),
              Obx(
                () =>
                    usernameError.value.isNotEmpty
                        ? Text(
                          usernameError.value,
                          style: TextStyle(color: Colors.red),
                        )
                        : Container(),
              ),
              CustomTextField(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'enter your email',
                obscureText: false,
              ),
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
                controller: passwordController,
                obscureText: true,
                hintText: 'enter your Password',
              ),
              Obx(
                () =>
                    passwordError.value.isNotEmpty
                        ? Text(
                          passwordError.value,
                          style: TextStyle(color: Colors.red),
                        )
                        : Container(),
              ),
              CustomTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
                hintText: 'enter Confirm Password',
              ),
              Obx(
                () =>
                    confirmPasswordError.value.isNotEmpty
                        ? Text(
                          confirmPasswordError.value,
                          style: TextStyle(color: Colors.red),
                        )
                        : Container(),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Sign up",
                onPressed: validateAndSignup,
                isPrimary: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () => Get.to(() => LoginPage()),
                    child: const Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
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
