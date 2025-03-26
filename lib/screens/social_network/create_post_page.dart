import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/user_data.dart';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';
import 'package:permission_handler/permission_handler.dart';


class CreatePostPage extends StatelessWidget {
  CreatePostPage({super.key});

  final PostController postController = Get.put(PostController());
  final ImagePicker _picker = ImagePicker();
  final logger = Logger();
  final uuid = Uuid();
  final Rx<XFile?> _image = Rx<XFile?>(null); // Utilisation de Rx pour GetX
  final TextEditingController _textController = TextEditingController();

  // Fonction pour générer un ID unique
  String generatePostId() {
    return uuid.v4();
  }

  // Fonction pour choisir une image depuis la galerie
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      _image.value = XFile(savedImage.path); // Mise à jour de l'image avec le nouveau chemin
    }
  }

  // Fonction pour publier le post
  void _submitPost() {
    String postText = _textController.text.trim();
    if (postText.isNotEmpty || _image.value != null) {
      Post post = Post(
        id: generatePostId(),
        user: currentUser,
        postText: postText,
        postImage: _image.value?.path, // Stocker uniquement le chemin de l'image
        createdAt: DateTime.now(),
        comments: [],
      );
      postController.addPost(post);
      logger.d("Post publié: $postText");
      if (_image.value != null) logger.d("Image ajoutée : ${_image.value!.path}");

      // Réinitialisation des champs après la publication
      _textController.clear();
      _image.value = null;
      Get.back(); // Fermer la page après publication
    } else {
      Get.snackbar("Erreur", "Le post ne peut pas être vide",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un post", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage de l'utilisateur actuel
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(currentUser.avatar),
                  ),
                  const SizedBox(width: 12),
                  Text(currentUser.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),

              // Champ de texte pour le post
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Quoi de neuf, ${currentUser.name} ?",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 20),

              // Affichage de l'image sélectionnée
              Obx(() => _image.value != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_image.value!.path), // Affichage avec le bon chemin
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : const SizedBox()),

              const SizedBox(height: 20),

              // Bouton pour sélectionner une image
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library, color: Colors.green),
                      label: const Text("Photo", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bouton pour publier
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text("Publier", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // La permission a été accordée
    } else {
      // La permission n'a pas été accordée
    }
  }
}
