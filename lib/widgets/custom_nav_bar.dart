import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  CustomNavBar({required this.currentIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.blue,
          activeColor: Colors.blue,
          tabBackgroundColor: const Color.fromARGB(255, 142, 200, 248),
          gap: 8,
          selectedIndex: currentIndex, // Garde la sélection correcte
          onTabChange: onTabChange, // Change de page lors d'un clic

          padding: EdgeInsets.all(16),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.storefront_sharp, text: 'Marketplace'),
            GButton(icon: Icons.library_books, text: 'Diary'),
            GButton(icon: Icons.account_circle, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
