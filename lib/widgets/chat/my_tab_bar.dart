import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    required this.tabController,
    required Key key,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      padding: const EdgeInsets.all(8),
      height: 55, // Augmenté pour plus de visibilité
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Gris clair pour l’arrière-plan
        borderRadius: BorderRadius.circular(30), // Coins plus arrondis
      ),
      child: Expanded(
        child: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: const Color(0xff0095FF), // Violet pour l’onglet sélectionné
            borderRadius: BorderRadius.circular(30), // Arrondi parfait
          ),
          labelColor: Colors.white, // Texte blanc pour l’onglet actif
          unselectedLabelColor: Colors.black, // Texte noir pour les inactifs
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18, // Taille augmentée
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          tabs: const [
            Tab(text: 'chats'),
            Tab(text: 'groups'),
          ],
        ),
      ),
    );
  }
}
