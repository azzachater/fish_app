import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/event/event_page.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:fish_app/screens/predict_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../screens/chat/chat_home_page.dart';
import '../../screens/map_page.dart';
import '../../screens/social_network/profile_page.dart';
import '../../screens/tips_and_tricks/tip_page.dart';
import '../journal/diary_screen.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  SidebarPageState createState() => SidebarPageState();
}

class SidebarPageState extends State<SidebarPage> {
  int selectedIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _userController.fetchCurrentUser();
  }

  void _onItemTapped(int index, Widget? page) {
    setState(() {
      selectedIndex = index;
    });
    if (page != null) {
      Get.to(
        () => page,
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar('Information', 'Cette fonctionnalité arrive bientôt!');
    }
  }

  void _logout() {
    _authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Column(
        children: [
          _buildProfileSection(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.list, "Lists", null, selected: true, iconColor: Colors.blue),
                _buildDrawerItem(Icons.person, "Profile", ProfilePage(), iconColor: Colors.green),
                _buildDrawerItem(FontAwesomeIcons.facebookMessenger, "Messages", ChatHomePage(), 
                    hasNotification: true, iconColor: Colors.blue),
                _buildDrawerItem(Icons.assessment, "Predict Species", PredictPage(), iconColor: Colors.pink),
                _buildDrawerItem(Icons.lightbulb, "Tips & Tricks", TipsPage(), iconColor: Colors.orange),
                _buildDrawerItem(Icons.event, "Events", EventPage(), iconColor: Colors.red), // Corrigé ici
                _buildDrawerItem(Icons.book, "Journal", JournalScreen(), iconColor: Colors.indigo),
                _buildDrawerItem(Icons.location_on, "Spot", MapPage(), iconColor: Colors.teal),
                _buildDrawerItem(Icons.storefront, "Marketplace", Marketplace(), iconColor: Colors.amber),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          _buildDrawerItem(Icons.exit_to_app, "Log Out", null, iconColor: Colors.black, onTap: _logout),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Obx(() {
      final user = _userController.currentUser.value;

      if (_userController.error.value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Erreur: ${_userController.error.value}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: (user?.avatar != null && user!.avatar.isNotEmpty)
                  ? (user.avatar.startsWith('http')
                      ? NetworkImage(user.avatar)
                      : AssetImage(user.avatar) as ImageProvider)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Utilisateur inconnu',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      trailing: hasNotification
          ? const Icon(Icons.circle, color: Colors.blue, size: 10)
          : null,
      tileColor: selected ? Colors.blue.shade100 : Colors.transparent,
      onTap: onTap ?? () => _onItemTapped(0, page),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: Colors.blue.shade50,
    );
  }
}