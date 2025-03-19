import 'package:flutter/material.dart';
import '../../models/user_model.dart'; // Assurez-vous d'importer votre modèle User
import '../../screens/chat/chat_room.dart'; // Pour naviguer vers la page de chat
import '../../constants/theme.dart';
import '../../data/user_data.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  SearchUsersPageState createState() => SearchUsersPageState();
}

class SearchUsersPageState extends State<SearchUsersPage> {
  TextEditingController searchController = TextEditingController();
  List<User> filteredUsers = users; // Initialize with all users

  void filterUsers(String query) {
    final List<User> results = users.where((user) {
      final String userName = user.name.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return userName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)), // 0.7 * 255 = 179
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            filterUsers(value); // Filtrer les utilisateurs en fonction de la saisie
          },
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length, // Utiliser la liste filtrée
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
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
      ),
    );
  }
}