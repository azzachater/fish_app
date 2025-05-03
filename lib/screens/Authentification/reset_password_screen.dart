import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ResetPasswordScreen({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPrimary,
      appBar: AppBar(
        title: const Text('Réinitialiser le mot de passe'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Un code a été envoyé à :',
                style: AppTheme.bodyText1.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTheme.heading2.copyWith(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Code de vérification', _codeController),
              Obx(
                () =>
                    _authController.resetTokenError.value.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _authController.resetTokenError.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                        : Container(),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Nouveau mot de passe',
                _newPasswordController,
                obscure: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'Confirmez le mot de passe',
                _confirmPasswordController,
                obscure: true,
              ),
              Obx(
                () =>
                    _authController.resetPasswordError.value.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _authController.resetPasswordError.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                        : Container(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      () => _authController.verifyAndResetPassword(
                        email: email,
                        code: _codeController.text.trim(),
                        newPassword: _newPasswordController.text.trim(),
                        confirmPassword: _confirmPasswordController.text.trim(),
                      ),
                  child: const Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
