import 'package:fish_app/screens/chat/chat_home_page.dart';
import 'package:fish_app/screens/event/event_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../data/user_data.dart';
import '../../screens/social_network/profile_page.dart';
import '../../screens/tips_and_tricks/tip_page.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  SidebarPageState createState() => SidebarPageState();
}

class SidebarPageState extends State<SidebarPage> {
  int selectedIndex = 0;

  void _onItemTapped(int index, Widget? page) {
    setState(() {
      selectedIndex = index;
    });
    if (page != null) {
      Get.to(() => page); // Utilisation de Get.to() pour la navigation
    }
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
                  EventPage(), // Lier la page EventPage ici
                  iconColor: Colors.red,
                ),
                _buildDrawerItem(
                  Icons.book,
                  "Journal",
                  null,
                  iconColor: Colors.indigo,
                ),
                _buildDrawerItem(
                  Icons.location_on,
                  "Spot",
                  null,
                  iconColor: Colors.teal,
                  onTap: () {
                    Get.toNamed('/map');
                  },
                ),
                _buildDrawerItem(
                  Icons.storefront,
                  "Marketplace",
                  null,
                  iconColor: Colors.amber,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          _buildDrawerItem(
            Icons.exit_to_app,
            "Log Out",
            null,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
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
            radius: 40,
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
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      trailing:
          hasNotification
              ? const Icon(Icons.circle, color: Colors.blue, size: 10)
              : null,
      tileColor: selected ? Colors.blue.shade100 : Colors.transparent,
      onTap: onTap ?? () => _onItemTapped(0, page),
    );
  }
}
