import 'package:flutter/material.dart';
import '../../widgets/social_network/create_post_widget.dart';
import '../../widgets/social_network/post_widget.dart';
import '../../data/post_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sidebar.dart'; // Importez votre fichier sidebar.dart
import '../chat/chat_home_page.dart';
import 'search_profile_page.dart'; // Importer la page de recherche de profil
import '../../data/user_data.dart';

class SocialHomePage extends StatelessWidget {
  const SocialHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fond blanc
        elevation: 3, // Ombre subtile
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black), // Hamburger menu en noir
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'FishNet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5, // Espacement comme Facebook
          ),
        ),
        centerTitle: true, // Centrer le titre
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
           onPressed: () {
  // Rediriger vers SearchProfilePage en passant la liste des utilisateurs
            Navigator.push(
            context,
                MaterialPageRoute(
      builder: (context) => SearchProfilePage(users: users), // Passer la liste des utilisateurs
    ),
  );
},
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.facebookMessenger, color: Colors.black),
            onPressed: () {
              // Navigate to HomePage when the icon is pressed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatHomePage()),
              );
            },
          ),
        ],
      ),
      drawer: const SidebarPage(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CreatePostWidget(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostWidget(post: posts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
