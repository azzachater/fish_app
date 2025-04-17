import 'package:fish_app/service/api_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiAuthService _apiAuthService = ApiAuthService();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = Rxn<User>();

  // Variables for error messages
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var usernameError = ''.obs;
  var confirmPasswordError = ''.obs;
  var generalError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  /// Checks if a valid token exists to maintain session
  Future<void> checkLoginStatus() async {
    bool hasToken = await _apiAuthService.hasValidToken();
    isLoggedIn.value = hasToken;
    if (hasToken) {
      // Redirect to the main screen
      Get.offAllNamed('/MainScreen');
    }
  }

  /// Validates fields and logs the user in via API
  Future<void> login(String email, String password) async {
  try {
    _resetErrors();
    _validateLoginFields(email, password);
    if (emailError.isNotEmpty || passwordError.isNotEmpty) return;

    isLoading.value = true;
    final loggedInUser = await _apiAuthService.login(email, password);
    
    user.value = loggedInUser;
    isLoggedIn.value = true;
    Get.offAllNamed('/MainScreen');

  } on Exception catch (e) {
    if (e.toString().contains('EmailNotVerified')) {
      Get.offAllNamed('/verify-email', arguments: {'email': email});
    }
    generalError.value = _handleAuthError(e);
  } finally {
    isLoading.value = false;
  }
}

  /// Registers a user by calling the API
  Future<void> signup(
      String username,
      String email,
      String password,
      String confirmPassword,
      ) async {
    try {
      _resetErrors();
      _validateSignupFields(username, email, password, confirmPassword);

      if (usernameError.isNotEmpty ||
          emailError.isNotEmpty ||
          passwordError.isNotEmpty) return;

      isLoading.value = true;
      final newUser = await _apiAuthService.register(
        username,
        email,
        password,
        confirmPassword,
      );

      user.value = newUser;
      // Passer à la fois l'email et l'ID utilisateur
      Get.offAllNamed('/verify-code', arguments: {
        'email': email,
        'userId': newUser.id,
      });

    } catch (e) {
      generalError.value = _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyCode({required int userId, required String code}) async {
    try {
      isLoading(true);
      final response = await _apiAuthService.verifyCode(userId, code);

      // Après vérification réussie, obtenir le token et connecter l'utilisateur
      if (response.containsKey('token')) {
        await _apiAuthService.storage.write(key: 'token', value: response['token']);
        isLoggedIn.value = true;
        Get.offAllNamed('/MainScreen');
      }

      Get.snackbar('Succès', response['message'] ?? 'Email vérifié avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Logs out the user by deleting the token and redirecting to login
  Future<void> logout() async {
    await _apiAuthService.storage.delete(key: 'token');
    isLoggedIn.value = false;
    user.value = null;
    Get.offAllNamed('/login');
  }

  // 🛠 Validation methods for fields

  void _resetErrors() {
    emailError.value = '';
    passwordError.value = '';
    usernameError.value = '';
    generalError.value = '';
  }
  String _handleAuthError(dynamic error) {
    if (error.toString().contains('Email not verified')) {
      return 'Please verify your email first';
    } else if (error.toString().contains('credentials')) {
      return 'Invalid email or password';
    }
    return 'An error occurred. Please try again.';
  }
  void _validateLoginFields(String email, String password) {
    if (email.isEmpty) emailError.value = 'Email is required';
    else if (!GetUtils.isEmail(email)) emailError.value = 'Invalid email format';

    if (password.isEmpty) passwordError.value = 'Password is required';
    else if (password.length < 6) passwordError.value = 'Password too short';
  }
  void _validateSignupFields(
      String username,
      String email,
      String password,
      String confirmPassword,
      ) {
    _validateLoginFields(email, password);

    if (username.isEmpty) usernameError.value = 'Username is required';
    if (password != confirmPassword) {
      passwordError.value = 'Passwords do not match';
    }
  }



  Future<void> resendCode(int userId) async {
    try {
      isLoading(true);
      await _apiAuthService.resendCode(userId);
      Get.snackbar('Succès', 'Nouveau code envoyé');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }

}