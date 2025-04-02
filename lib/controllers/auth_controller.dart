import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_auth_service.dart';
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
    emailError.value = validateEmail(email) ?? '';
    passwordError.value = validatePassword(password) ?? '';

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      User loggedInUser = await _apiAuthService.login(email, password);
      user.value = loggedInUser;
      isLoggedIn.value = true;
      Get.offAllNamed('/MainScreen');
    } catch (e) {
      generalError.value = e.toString();
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
    usernameError.value = validateUsername(username) ?? '';
    emailError.value = validateEmail(email) ?? '';
    passwordError.value = validatePassword(password) ?? '';
    confirmPasswordError.value =
        validateConfirmPassword(password, confirmPassword) ?? '';

    if (usernameError.isNotEmpty ||
        emailError.isNotEmpty ||
        passwordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      User newUser = await _apiAuthService.register(
        username,
        email,
        password,
        confirmPassword,
      );
      user.value = newUser;
      isLoggedIn.value = true;
      Get.offAllNamed('/login');
    } catch (e) {
      generalError.value = e.toString();
    } finally {
      isLoading.value = false;
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
  String? validateEmail(String email) {
    if (email.isEmpty) return 'Email cannot be empty';
    if (!GetUtils.isEmail(email)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Confirm password cannot be empty';
    if (confirmPassword != password) return 'Passwords do not match';
    return null;
  }

  String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty';
    return null;
  }
}
