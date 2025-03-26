import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/chat/chat_room.dart';
import '../../constants/theme.dart';
import 'package:fish_app/controllers/chat_controller.dart';

class SearchUsersPage extends StatelessWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    final searchController = TextEditingController();

    // Réinitialiser les utilisateurs lorsqu'on entre dans la page
    chatController.filterUsers(""); 

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            chatController.filterUsers(value); // Filtrer les utilisateurs en fonction de la saisie
          },
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: chatController.filteredUsers.length, // Utiliser la liste filtrée de GetX
          itemBuilder: (context, index) {
            final user = chatController.filteredUsers[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(user.avatar), // Photo de profil
              ),
              title: Text(
                user.name,
                style: AppTheme.heading2.copyWith(fontSize: 16),
              ),
              onTap: () {
                // Naviguer vers la page de chat avec l'utilisateur sélectionné
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoom(user: user),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
