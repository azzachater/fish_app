import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'map_selection_page.dart';
import 'package:logger/logger.dart'; 
//import '../models/user_model.dart';
import '../../data/user_data.dart';
import 'create_status_page.dart'; // Importation du modèle utilisateur

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() => CreatePostPageState();
}

class CreatePostPageState extends State<CreatePostPage> {
  //LatLng? selectedLocation;
  String _postText = '';
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final logger = Logger();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _submitPost() {
    if (_postText.isNotEmpty || _image != null) {
      logger.d("Post envoyé : $_postText");
      if (_image != null) logger.d("Image ajoutée : ${_image!.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un post", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(currentUser.avatar), // Utilisation de l'avatar actuel
                  ),
                  SizedBox(width: 12),
                  Text(currentUser.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 20),

              TextField(
                onChanged: (value) {
                  setState(() {
                    _postText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Quoi de neuf, ${currentUser.name} ?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),

              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_image!.path),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo_library, color: Colors.green),
                      label: Text("Photo", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateStatusPage()),
                                );      
                              },
                      icon: Icon(Icons.edit, color: Colors.blue),
                      label: Text("Status", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    "Publier",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
