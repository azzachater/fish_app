import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/screens/event/event_page.dart';
import 'package:fish_app/screens/journal/diary_screen.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../data/user_data.dart'; // Assurez-vous que ce fichier contient `currentUser`
import '../../screens/chat/chat_home_page.dart';
import '../../screens/map_page.dart';
import '../../screens/social_network/profile_page.dart';
import '../../screens/tips_and_tricks/tip_page.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  SidebarPageState createState() => SidebarPageState();
}

class SidebarPageState extends State<SidebarPage> {
  int selectedIndex = 0;

  // Instance du AuthController
  final AuthController _authController = Get.find<AuthController>();

  void _onItemTapped(int index, Widget? page) {
    setState(() {
      selectedIndex = index;
    });
    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Column(
        children: [
          _buildProfileSection(), // Profil en haut du drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.list,
                  "Lists",
                  null,
                  selected: true,
                  iconColor: Colors.blue,
                ),
                _buildDrawerItem(
                  Icons.person,
                  "Profile",
                  ProfilePage(),
                  iconColor: Colors.green,
                ),
                _buildDrawerItem(
                  FontAwesomeIcons.facebookMessenger,
                  "Messages",
                  ChatHomePage(),
                  hasNotification: true,
                  iconColor: Colors.blue,
                ),
                _buildDrawerItem(
                  Icons.lightbulb,
                  "Tips & Tricks",
                  TipsPage(),
                  iconColor: Colors.orange,
                ),
                _buildDrawerItem(
                  Icons.event,
                  "Event",
                  EventPage(),
                  iconColor: Colors.red,
                ),
                _buildDrawerItem(
                  Icons.book,
                  "Journal",
                  JournalScreen(),
                  iconColor: Colors.indigo,
                ),
                _buildDrawerItem(
                  Icons.location_on,
                  "Spot",
                  MapPage(),
                  iconColor: Colors.teal,
                ),
                _buildDrawerItem(
                  Icons.storefront,
                  "Marketplace",
                  Marketplace(),
                  iconColor: Colors.amber,
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ), // Divider before sign out
          _buildDrawerItem(
            Icons.exit_to_app,
            "Log Out",
            null,
            iconColor: Colors.black,
            onTap: _logout,
          ), // Lier le logout
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
        bottom: 20,
      ), // Augmenter l'espace autour du profil
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40, // Agrandir l'avatar pour plus de visibilité
            backgroundImage:
                currentUser.avatar.startsWith('http')
                    ? NetworkImage(currentUser.avatar)
                    : AssetImage(currentUser.avatar) as ImageProvider,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              currentUser.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    Widget? page, {
    bool hasNotification = false,
    bool selected = false,
    Color iconColor = Colors.black,
    Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor), // Icône avec couleur
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      trailing:
          hasNotification
              ? const Icon(Icons.circle, color: Colors.blue, size: 10)
              : null,
      tileColor:
          selected
              ? Colors.blue.shade100
              : Colors.transparent, // Fond léger si sélectionné
      onTap:
          onTap ?? () => _onItemTapped(0, page), // Utiliser onTap pour logout
      contentPadding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 10,
      ), // Réduction de l'espacement pour une conception plus compacte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ), // Coins arrondis pour un look moderne
      hoverColor: Colors.blue.shade50, // Effet de survol
      onLongPress:
          () => _onItemTapped(
            0,
            page,
          ), // Appui long pour une meilleure interaction
    );
  }

  // Méthode de déconnexion
  void _logout() {
    _authController.logout(); // Appeler la méthode de déconnexion du contrôleur
  }
}
