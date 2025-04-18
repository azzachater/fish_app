import 'package:fish_app/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../controllers/user_controller.dart';
//import '../../services/api_user_service.dart';
import '../../services/api_profile_service.dart';

class ProfileController extends GetxController {
  final UserController userController = Get.find<UserController>(); // CHANGÉ

  final ApiProfileService _apiProfileService = ApiProfileService();

  var user = Rxn<User>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedImagePath = ''.obs;


  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  RxString imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    //loadUserProfile();
  }
 // Add this method
  void resetProfile() {
    user.value = null;
    usernameController.clear();
    emailController.clear();
    bioController.clear();
    imagePath.value = '';
    errorMessage.value = '';
  }
  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.onClose();
  }

   Future<void> loadUserProfile() async {
    try {
      isLoading(true);
      errorMessage('');
      resetProfile(); // Clear old data first
      
      // Forcer un rafraîchissement depuis le serveur
      await userController.fetchCurrentUser();
      
      final currentUser = userController.currentUser.value;
      if (currentUser != null) {
        user.value = currentUser.copyWith(); // Crée une nouvelle instance
        usernameController.text = currentUser.name;
        emailController.text = currentUser.email;
        bioController.text = currentUser.bio ?? '';
        imagePath.value = currentUser.avatar ?? '';
        
        print('User profile loaded: ${currentUser.toJson()}');
      }
    } catch (e) {
      errorMessage('Erreur lors du chargement du profil: ${e.toString()}');
      print('Error loading profile: $e');
      Get.snackbar('Erreur', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }


  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
      }
    } catch (e) {
      errorMessage('Erreur lors de la sélection de l\'image');
      Get.snackbar('Erreur', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveProfile() async {
  try {
    isLoading(true);
    errorMessage('');

    final updatedUser = await _apiProfileService.updateProfile(
      usernameController.text.trim(),
      emailController.text.trim(),
      bioController.text.trim(),
      imagePath.value.isNotEmpty ? imagePath.value : null,
    );

    // 🔄 Mettre à jour currentUser
    userController.currentUser.value = updatedUser;

    // 🔁 Recharger tous les utilisateurs pour mettre à jour la SearchPage aussi
    await userController.fetchAllUsers(); // ✅ AJOUT ESSENTIEL

    // ✅ Mettre à jour localement
    user.value = updatedUser;
    usernameController.text = updatedUser.name;
    emailController.text = updatedUser.email;
    bioController.text = updatedUser.bio ?? '';
    imagePath.value = updatedUser.avatar ?? '';

    // ✅ ➕ Ajoute ceci pour recharger les posts
    final postController = Get.put(PostController());
    await postController.fetchPosts();

    Get.back();
    Get.snackbar('Succès', 'Profil mis à jour avec succès',
        snackPosition: SnackPosition.BOTTOM);
  } catch (e) {
    errorMessage('Erreur lors de la mise à jour: ${e.toString()}');
    Get.snackbar('Erreur', errorMessage.value,
        snackPosition: SnackPosition.BOTTOM);
    print('Error saving profile: $e');
  } finally {
    isLoading(false);
  }
}
}