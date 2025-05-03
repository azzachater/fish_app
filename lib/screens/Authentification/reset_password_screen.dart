import 'package:fish_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ResetPasswordScreen({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réinitialisation du mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Un code a été envoyé à $email'),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code de vérification'),
              ),
              Obx(() => Text(
                    _authController.resetTokenError.value,
                    style: const TextStyle(color: Colors.red),
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmez le mot de passe'),
              ),
              Obx(() => Text(
                    _authController.resetPasswordError.value,
                    style: const TextStyle(color: Colors.red),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _authController.verifyAndResetPassword(
                  email: email,
                  code: _codeController.text.trim(),
                  newPassword: _newPasswordController.text.trim(),
                  confirmPassword: _confirmPasswordController.text.trim(),
                ),
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
