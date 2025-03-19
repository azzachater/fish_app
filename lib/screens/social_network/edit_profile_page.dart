import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_button.dart'; // Assurez-vous d'importer votre widget CustomButton
import '../../widgets/custom_text_field.dart'; // Assurez-vous d'importer votre widget CustomTextField

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String? imagePath;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          // Section du formulaire
          Positioned(
            top: 150, // Ajustez cette valeur pour superposer l'image
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30), // Espace pour l'image superposée
                      Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      CustomTextField(label: 'First Name', controller: firstNameController),
                      CustomTextField(label: 'Last Name', controller: lastNameController),
                      CustomTextField(label: 'Username', controller: usernameController),
                      CustomTextField(label: 'Email', controller: emailController),
                      CustomTextField(label: 'Bio', controller: bioController, maxLines: 3),
                      SizedBox(height: 20),
                      imagePath != null
                          ? Image.file(File(imagePath!), height: 150, fit: BoxFit.cover)
                          : SizedBox.shrink(),
                      CustomButton(
                        text: 'Save',
                        onPressed: () {},
                        isPrimary: true, // Ajoutez l'argument isPrimary
                      ),
                      SizedBox(height: 20), // Optionnel : ajout d'un peu d'espace après le bouton
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Section de l'image et du bouton retour
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 80, // Ajustez cette valeur pour positionner l'image
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!)) as ImageProvider
                        : AssetImage('assets/images/users/Addison.jpg'),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Colors.black, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}