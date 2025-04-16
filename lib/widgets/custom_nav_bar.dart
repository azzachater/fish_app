import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Ajustement dynamique en fonction de la largeur disponible
              final isSmallScreen = constraints.maxWidth < 400;

              return GNav(
                backgroundColor: Colors.white,
                color: Colors.blue,
                activeColor: Colors.blue,
                tabBackgroundColor: const Color.fromARGB(255, 142, 200, 248),
                gap: isSmallScreen ? 4 : 8,
                selectedIndex: currentIndex,
                onTabChange: onTabChange,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 10 : 12,
                ),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconSize: isSmallScreen ? 20 : 24,
                  ),
                  GButton(
                    icon: Icons.storefront_sharp,
                    text: 'Marketplace',
                    iconSize: isSmallScreen ? 20 : 24,
                  ),
                  GButton(
                    icon: Icons.library_books,
                    text: 'Diary',
                    iconSize: isSmallScreen ? 20 : 24,
                  ),
                  GButton(
                    icon: Icons.analytics,
                    text: isSmallScreen ? 'Stats' : 'Prévisions',
                    iconSize: isSmallScreen ? 20 : 24,
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    text: 'Profile',
                    iconSize: isSmallScreen ? 20 : 24,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
