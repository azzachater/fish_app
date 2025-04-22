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
    final PostController postController = Get.put(
      PostController(),
    ); // Obtenez l'instance du contrôleur PostController
    final NotificationController notificationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff3c79d8), // Bleu clair
                Color(0xff044ab1), // Bleu plus soutenu
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'FishNet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.facebookMessenger,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHomePage()),
              );
            },
          ),
          Obx(() {
            final hasUnread = notificationController.unreadStatus.value;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bell, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                ),
                if (hasUnread)
                  const Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
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
