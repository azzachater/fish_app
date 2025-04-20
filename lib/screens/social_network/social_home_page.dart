import 'package:fish_app/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../widgets/social_network/create_post_widget.dart';
import '../../widgets/social_network/post_widget.dart';
import 'sidebar.dart'; // Importez votre fichier sidebar.dart
import '../notification/notification_page.dart';
import 'search_profile_page.dart'; // Importer la page de recherche de profil
import '../../controllers/post_controller.dart'; // Importer le contrôleur des posts
import '../../models/post_model.dart'; 
import '../chat/chat_home_page.dart'; // Importez votre page de chat

class SocialHomePage extends StatelessWidget {
  const SocialHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController()); // Obtenez l'instance du contrôleur PostController
    final NotificationController notificationController = Get.find();

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
                  builder: (context) => SearchProfilePage(),
                ),
              );
            },
          ),
          // Icône Facebook Messenger
          IconButton(
            icon: const Icon(FontAwesomeIcons.facebookMessenger, color: Colors.black),
            onPressed: () {
              // Naviguer vers la page ChatHomePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHomePage(),
                ),
              );
            },
          ),
          Obx(() {
            final hasUnread = notificationController.unreadStatus.value;

            return Stack(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bell, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
                  },
                ),
                if (hasUnread)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      drawer: const SidebarPage(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreatePostWidget(),
            Obx(() {
              // Trie les posts directement ici
              List<Post> sortedPosts = List.from(postController.posts)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: sortedPosts[index]);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
