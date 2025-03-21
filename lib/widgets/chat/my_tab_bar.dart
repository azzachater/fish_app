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
      height: 50, // Hauteur légèrement augmentée pour plus de confort visuel
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25.0), // Coins plus arrondis
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab, // L'indicateur prend toute la largeur de l'onglet
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.blue.shade100,
        ),
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 18, // Taille augmentée pour une meilleure lisibilité
          fontWeight: FontWeight.bold, // Texte plus épais pour plus de visibilité
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16, // Taille un peu plus petite pour les onglets non sélectionnés
          fontWeight: FontWeight.w500, // Épaisseur moyenne pour les inactifs
        ),
        tabs: const [
          Tab(text: 'Chats'),
          Tab(text: 'Groups'),
        ],
      ),
    );
  }
}
