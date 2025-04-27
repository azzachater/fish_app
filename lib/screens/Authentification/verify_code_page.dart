import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyCodePage extends StatelessWidget {
  final String email;
  final int userId;

  const VerifyCodePage({super.key, required this.email, required this.userId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: AppTheme.primaryLight,
      appBar: AppBar(
        title: const Text('Vérification Email'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mark_email_read_rounded,
                  size: 60, color: AppTheme.primaryColor),
              const SizedBox(height: 20),
              Text(
                'Un code de vérification a été envoyé à',
                style: GoogleFonts.roboto(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: "",
                  labelText: 'Code à 6 chiffres',
                  labelStyle: GoogleFonts.roboto(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.primaryLight.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (codeController.text.length == 6) {
                            await authController.verifyCode(
                              userId: userId,
                              code: codeController.text,
                            );
                          } else {
                            Get.snackbar('Erreur', 'Le code doit contenir 6 chiffres',
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800]);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Vérifier'),
                      ),
                    )),
              TextButton(
                onPressed: () => authController.resendCode(userId),
                child: Text(
                  'Renvoyer le code',
                  style: GoogleFonts.roboto(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}