import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/user_data.dart'; // Importer vos données utilisateur actuelles

class EditProfileController extends GetxController {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmationController = TextEditingController();
  var bioController = TextEditingController();

  String? imagePath;

  // Initialiser les contrôleurs avec les données de l'utilisateur actuel
  @override
  void onInit() {
    super.onInit();
    usernameController.text = currentUser.name;
    emailController.text = currentUser.email;
    passwordController.text = currentUser.password;
    passwordConfirmationController.text = currentUser.passwordConfirmation;
    bioController.text = currentUser.bio;
  }

  void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath = pickedFile.path;
      update();  // Notifier la mise à jour de l'UI
    }
  }

  // Sauvegarder les modifications
  void saveProfile() {
    currentUser.name = usernameController.text;
    currentUser.email = emailController.text;
    currentUser.password = passwordController.text;
    currentUser.passwordConfirmation = passwordConfirmationController.text;
    currentUser.bio = bioController.text;

    // Mettre à jour l'UI
    update();  // Utilisation de 'update()' pour notifier le changement
    Get.back();  // Retour à la page de profil
  }
}
