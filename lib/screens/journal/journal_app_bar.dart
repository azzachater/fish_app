import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/screens/social_network/social_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedView;
  final Function(String) onViewChange;

  const JournalAppBar({
    super.key,
    required this.selectedView,
    required this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'journal',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppTheme.primaryColor, // Couleur bleue unifiée
      elevation: 0,
      leading: IconButton(
        onPressed: () async {
          await Get.offAll(() => SocialHomePage());
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.lightPrimary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              _toggleButton('Day', selectedView == "Day"),
              _toggleButton('Week', selectedView == "Week"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => onViewChange(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.darkPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}