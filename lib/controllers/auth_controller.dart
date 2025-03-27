import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  // Variables pour les messages d'erreurs
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var usernameError = ''.obs;
  var confirmPasswordError = ''.obs;

  // Méthode de validation pour le login
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!GetUtils.isEmail(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    } else if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  // Login et Signup avec validation
  void login(String email, String password) {
    emailError.value = validateEmail(email) ?? '';
    passwordError.value = validatePassword(password) ?? '';

    if (emailError.value == '' && passwordError.value == '') {
      isLoggedIn.value = true;
      Get.offAllNamed('/MainScreen');
    }
  }

  void signup(String username, String email, String password, String confirmPassword) {
    usernameError.value = validateUsername(username) ?? '';
    emailError.value = validateEmail(email) ?? '';
    passwordError.value = validatePassword(password) ?? '';
    confirmPasswordError.value = validateConfirmPassword(password, confirmPassword) ?? '';

    if (usernameError.value == '' && emailError.value == '' && passwordError.value == '' && confirmPasswordError.value == '') {
      isLoggedIn.value = true;
      Get.offAllNamed('/MainScreen');
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
