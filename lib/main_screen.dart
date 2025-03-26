import 'package:fish_app/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/market_place.dart';
import 'screens/diary_screen.dart';
import 'screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Marketplace(),
    DiaryScreen(),
    ProfileScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Affiche la page active
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
