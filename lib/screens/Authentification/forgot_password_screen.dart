import 'package:fish_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mot de passe oublié')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            Obx(() => Text(
                  _authController.resetEmailError.value,
                  style: const TextStyle(color: Colors.red),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _authController.sendPasswordResetCode(
                _emailController.text.trim(),
              ),
              child: const Text('Envoyer le code'),
            ),
          ],
        ),
      ),
    );
  }
}
