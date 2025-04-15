import 'package:flutter/material.dart';
import '../../data/user_data.dart';
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
                backgroundImage: AssetImage(currentUser.avatar),
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
                      "Quoi de neuf, ${currentUser.name}?",
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.photo_library, color: Colors.green),
                onPressed: () => _navigateToCreatePost(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
