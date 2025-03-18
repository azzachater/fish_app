import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../constants/theme.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Créez des contrôleurs pour chaque champ de texte
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
              const Text("Sign up", style: AppTheme.titleStyle),
              const SizedBox(height: 10),
              const Text(
                "Create an account, It's free",
                style: AppTheme.subtitleStyle,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Username",
                controller: usernameController,
                hintText: 'Enter your username',
                obscureText: false,
              ),
              CustomTextField(
                label: "Email",
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false,
              ),
              CustomTextField(
                label: "Password",
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
              ),
              CustomTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                hintText: 'Confirm your password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Sign up",
                onPressed: () {
                  // Logique d'inscription
                  // Vous pouvez accéder aux valeurs des champs de texte comme ceci :
                  final username = usernameController.text;
                  final email = emailController.text;
                  final password = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  // Faites quelque chose avec ces valeurs, comme les valider ou les envoyer à un serveur
                },
                isPrimary: true, // Added the missing isPrimary parameter
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ),
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
