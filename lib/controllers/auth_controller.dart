import 'package:fish_app/controllers/profile_controller.dart';
import 'package:fish_app/screens/Authentification/reset_password_screen.dart';
import 'package:fish_app/service/api_auth_service.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'user_controller.dart'; // Ajouté

class AuthController extends GetxController {
  final ApiAuthService _apiAuthService = ApiAuthService();
  final UserController userController = Get.put(UserController()); // Ajouté

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = Rxn<User>();

  // Error messages
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var usernameError = ''.obs;
  var confirmPasswordError = ''.obs;
  var generalError = ''.obs;
  final RxString resetEmailError = ''.obs;
  final RxString resetTokenError = ''.obs;
  final RxString resetPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    bool hasToken = await _apiAuthService.hasValidToken();
    isLoggedIn.value = hasToken;
    if (hasToken) {
      await userController.fetchCurrentUser(); // 🆕
      Get.offAllNamed('/MainScreen');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _resetErrors();
      _validateLoginFields(email, password);
      if (emailError.isNotEmpty || passwordError.isNotEmpty) return;

      isLoading.value = true;
      final loggedInUser = await _apiAuthService.login(email, password);
      user.value = loggedInUser;
      isLoggedIn.value = true;

      userController.currentUser.value = null; // ✅ Vide les données précédentes
      await userController.fetchCurrentUser(); // ✅ Charge les vraies données

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
          passwordError.isNotEmpty)
        return;

      isLoading.value = true;
      final newUser = await _apiAuthService.register(
        username,
        email,
        password,
        confirmPassword,
      );
      user.value = newUser;

      Get.offAllNamed(
        '/verify-code',
        arguments: {'email': email, 'userId': newUser.id},
      );
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

      if (response.containsKey('token')) {
        await _apiAuthService.storage.write(
          key: 'token',
          value: response['token'],
        );
        isLoggedIn.value = true;
        await userController.fetchCurrentUser(); // ✅ charger après vérification
        Get.offAllNamed('/MainScreen');
      }

      Get.snackbar(
        'Succès',
        response['message'] ?? 'Email vérifié avec succès',
      );
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _apiAuthService.storage.delete(key: 'token');
    isLoggedIn.value = false;
    user.value = null;
    userController.currentUser.value = null; // ✅ vider currentUser aussi
    await Future.delayed(Duration(milliseconds: 100)); // Small delay
    Get.find<ProfileController>().resetProfile();
    Get.offAllNamed('/login');
  }

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
    if (email.isEmpty)
      emailError.value = 'Email is required';
    else if (!GetUtils.isEmail(email))
      emailError.value = 'Invalid email format';

    if (password.isEmpty)
      passwordError.value = 'Password is required';
    else if (password.length < 6)
      passwordError.value = 'Password too short';
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
Future<void> sendPasswordResetCode(String email) async {
  try {
    resetEmailError.value = '';

    if (!GetUtils.isEmail(email)) {
      resetEmailError.value = 'Email invalide';
      return;
    }

    isLoading(true);
    await _apiAuthService.sendResetCode(email);
    Get.snackbar('Succès', 'Code envoyé à $email');
    Get.to(() => ResetPasswordScreen(email: email)); // Navigue vers écran de reset
  } catch (e) {
    resetEmailError.value = e.toString();
  } finally {
    isLoading(false);
  }
}

Future<void> verifyAndResetPassword({
  required String email,
  required String code,
  required String newPassword,
  required String confirmPassword,
}) async {
  try {
    resetTokenError.value = '';
    resetPasswordError.value = '';

    if (code.isEmpty) {
      resetTokenError.value = 'Code requis';
    }
    if (newPassword.length < 8) {
      resetPasswordError.value = '8 caractères minimum';
    }
    if (newPassword != confirmPassword) {
      resetPasswordError.value = 'Les mots de passe ne correspondent pas';
    }
    if (resetTokenError.isNotEmpty || resetPasswordError.isNotEmpty) return;

    isLoading(true);

    // Étape 1 : Vérifier le code
    await _apiAuthService.verifyResetCode(email, code);

    // Étape 2 : Mettre à jour le mot de passe
    await _apiAuthService.updatePassword(email, newPassword, confirmPassword);

    Get.snackbar('Succès', 'Mot de passe mis à jour !');
    Get.offAllNamed('/login');
  } catch (e) {
    Get.snackbar('Erreur', e.toString());
  } finally {
    isLoading(false);
  }
}
}