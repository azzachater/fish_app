import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../screens/social_network/edit_profile_page.dart'; // Import the EditProfilePage

class ProfileHeaderWidget extends StatelessWidget {
  final User user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover Photo (utilisation de l'avatar aussi pour la couverture)
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(user.avatar), // Utilisation de l'avatar comme couverture
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile Picture, Name, and Edit Profile Button
          Transform.translate(
            offset: Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture with Camera Icon
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Larger Profile Picture, aligned to the left
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(user.avatar), // Profil dynamique
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.black, size: 20),
                          onPressed: () {
                            // Ajouter la logique pour changer la photo de profil
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Name
                  Text(
                    user.name, // Nom dynamique
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Edit Profile Button with Pencil Icon
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to EditProfilePage when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  EditProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Bio avec un style amélioré
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'I offer services for creating Brand Identity, Websites, and Website/App Design.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                        height: 1.5,
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
