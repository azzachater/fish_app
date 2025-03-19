import 'package:fish_app/screens/chat/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/user_data.dart'; // Assurez-vous que ce fichier contient `currentUser`
import '../../screens/social_network/profile_page.dart'; // Importer la page ProfilePage
import '../../screens/tips_and_tricks/tip_page.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  SidebarPageState createState() => SidebarPageState();
}

class SidebarPageState extends State<SidebarPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, Widget page) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10, // Ombre pour ajouter de la profondeur
      child: Container(
        color: Colors.white, // Fond blanc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(0, Icons.person, 'Profile', ProfilePage()),
                  _buildListTile(1, FontAwesomeIcons.facebookMessenger, 'Messages', ChatHomePage()),
                  _buildListTile(5, Icons.edit, 'Edit Profile', null),
                  _buildListTile(4, Icons.notifications, 'Notifications', null),
                  _buildListTile(2, Icons.event, 'Events', null),
                  _buildListTile(3, Icons.lightbulb, 'Tips', TipsPage()),
                  _buildListTile(6, Icons.book, 'Journal', null), // Ajout du Journal avec l'icône
                  _buildListTile(7, FontAwesomeIcons.store, 'Marketplace', null), // Ajout du Marketplace avec l'icône
                ],
              ),
            ),
            const Divider(color: Colors.black26),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black87),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Arrière-plan léger pour la section profil
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: currentUser.avatar.startsWith('http')
                ? NetworkImage(currentUser.avatar)
                : AssetImage(currentUser.avatar) as ImageProvider,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Texte sombre pour le nom
                ),
              ),
              Text(
                currentUser.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // Texte sombre pour l'email
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(int index, IconData icon, String title, Widget? page) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? Colors.blue : Colors.black54, // Couleur bleue pour l'élément sélectionné
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.black87, // Couleur bleue pour l'élément sélectionné
          fontWeight: FontWeight.bold,
        ),
      ),
      tileColor: _selectedIndex == index ? Colors.blue.withOpacity(0.1) : null, // Fond bleu léger pour l'élément sélectionné
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: page != null ? () => _onItemTapped(index, page) : null,
    );
  }
}
