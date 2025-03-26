import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login() {
    isLoggedIn.value = true;
    Get.offAllNamed('/socialHome'); // Redirection après connexion
  }

  void signup() {
    isLoggedIn.value = true;
    Get.offAllNamed('/socialHome'); // Redirection après inscription
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Redirection vers login après déconnexion
  }
}
