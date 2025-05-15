import 'package:fish_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodePage extends StatelessWidget {
  final String email;
  final int userId;

  const VerifyCodePage({super.key, required this.email, required this.userId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Vérification Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Un code de vérification a été envoyé à $email'),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Code de vérification',
                border: OutlineInputBorder(),
                hintText: 'Entrez le code à 6 chiffres',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            Obx(() => authController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (codeController.text.length == 6) {
                        await authController.verifyCode(
                          userId: userId,
                          code: codeController.text,
                        );
                      } else {
                        Get.snackbar('Erreur', 'Le code doit contenir 6 chiffres');
                      }
                    },
                    child: const Text('Vérifier'),
                  )),
            TextButton(
              onPressed: () => authController.resendCode(userId),
              child: const Text('Renvoyer le code'),
            ),
          ],
        ),
      ),
    );
  }
}