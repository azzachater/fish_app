import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class UsersProfileHeader extends StatelessWidget {
  final User user;

  const UsersProfileHeader({super.key, required this.user});

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
              image: const DecorationImage(
                image: AssetImage('assets/images/cover_default_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile Picture and Name
          Transform.translate(
            offset: Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture without Camera Icon
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(user.avatar), // Profil dynamique
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
