import 'package:flutter/material.dart';
//import '../models/user_model.dart';
import '../../data/user_data.dart'; // Assure-toi que ces fichiers sont bien configurés
import '../../screens/social_network/create_post_page.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key});

  void _navigateToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(currentUser.avatar), // Utilisation de l'avatar de currentUser
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _navigateToCreatePost(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "What's on your mind, ${currentUser.name}?",
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(thickness: 1, color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPostOption(context, Icons.photo_library, "Photo", Colors.green),
              _buildPostOption(context, Icons.edit, "Status", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostOption(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () => _navigateToCreatePost(context),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
