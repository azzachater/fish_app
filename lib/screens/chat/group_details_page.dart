import 'package:fish_app/data/group_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Importer le package image_picker
import 'dart:io';  // Importer pour manipuler les fichiers image
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../constants/theme.dart';

class GroupDetailsPage extends StatefulWidget {
  final List<User> selectedUsers;

  const GroupDetailsPage({super.key, required this.selectedUsers});

  @override
  GroupDetailsPageState createState() => GroupDetailsPageState();
}

class GroupDetailsPageState extends State<GroupDetailsPage> {
  TextEditingController groupNameController = TextEditingController();
  String? groupImage; // Variable pour stocker l'image du groupe
  final ImagePicker _picker = ImagePicker();  // Instance de ImagePicker

  // Fonction pour sélectionner une image depuis la galerie
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        groupImage = pickedFile.path;  // Enregistrer le chemin de l'image
      });
    }
  }

  void createGroup() {
    if (groupNameController.text.isNotEmpty && groupImage != null) {  // Vérifier que le nom et l'image sont renseignés
      final newGroup = Group(
        name: groupNameController.text,
        avatar: groupImage!, // Utiliser l'image sélectionnée pour l'avatar
        admin: widget.selectedUsers[0],  // Le premier utilisateur sélectionné comme administrateur
        members: widget.selectedUsers,
        unreadCount: 0,
        isRead: true,
        time: '12:00 PM',
        id: '',
      );

      // Ajouter le nouveau groupe à la liste de tous les groupes
      allGroups.add(newGroup);

      // Naviguer vers la page précédente avec le nouveau groupe ajouté
      Navigator.pop(context, newGroup);  // Retourner le groupe créé
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Section pour sélectionner une image
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: groupImage == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : Image.file(File(groupImage!), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Users',
              style: AppTheme.heading2,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.selectedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    title: Text(
                      user.name,
                      style: AppTheme.heading2.copyWith(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
