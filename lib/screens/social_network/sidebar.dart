import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/event/event_page.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:fish_app/screens/predict_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      child: Container(
        decoration: BoxDecoration(gradient: AppTheme.lightGradient),
        child: Column(
          children: [
            _buildProfileSection(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 20),
                  _buildDrawerItem(
                    0,
                    Icons.list_alt_rounded,
                    "Lists",
                    null,
                    selected: selectedIndex == 0,
                  ),
                  _buildDrawerItem(
                    1,
                    Icons.person_outline_rounded,
                    "Profile",
                    ProfilePage(),
                    selected: selectedIndex == 1,
                  ),
                  _buildDrawerItem(
                    3,
                    Icons.analytics_outlined,
                    "Predict Species",
                    PredictPage(),
                    selected: selectedIndex == 3,
                  ),
                  _buildDrawerItem(
                    4,
                    Icons.lightbulb_outline_rounded,
                    "Tips & Tricks",
                    TipsPage(),
                    selected: selectedIndex == 4,
                  ),
                  _buildDrawerItem(
                    5,
                    Icons.event_note_rounded,
                    "Events",
                    EventPage(),
                    selected: selectedIndex == 5,
                  ),
                   _buildDrawerItem(
                    7,
                    Icons.location_on_outlined,
                    "Spot",
                    MapPage(),
                    selected: selectedIndex == 7,
                  ),
                  _buildDrawerItem(
                    6,
                    Icons.book_outlined,
                    "Journal",
                    JournalScreen(),
                    selected: selectedIndex == 6,
                  ),
                  _buildDrawerItem(
                    8,
                    Icons.store_mall_directory_outlined,
                    "Marketplace",
                    Marketplace(),
                    selected: selectedIndex == 8,
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Obx(() {
      final user = _userController.currentUser.value;

      if (_userController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

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
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.darkPrimary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.accent, AppTheme.primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    (user?.avatar != null && user!.avatar.isNotEmpty)
                        ? (user.avatar.startsWith('http')
                                ? NetworkImage(user.avatar)
                                : AssetImage(user.avatar))
                            as ImageProvider
                        : const AssetImage('assets/images/default_avatar.png'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Utilisateur inconnu',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
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
    int index,
    IconData icon,
    String title,
    Widget? page, {
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? AppTheme.primaryColor : AppTheme.textDark,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.roboto(
            color: selected ? AppTheme.primaryColor : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: () => _onItemTapped(index, page),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: _logout,
    );
  }
}