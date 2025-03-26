import 'package:fish_app/controllers/search_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_profile_page.dart';  // Import de la page de profil

class SearchProfilePage extends StatelessWidget {
  const SearchProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProfileController controller = Get.put(SearchProfileController()); // Initialisation du contrôleur

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return controller.isSearching.value
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    controller.filterUsers(query); // Filtrage des utilisateurs en temps réel
                  },
                )
              : const Text('Search Users');
        }),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Obx(() {
              return controller.isSearching.value
                  ? const Icon(Icons.cancel)
                  : const Icon(Icons.search);
            }),
            onPressed: () {
              controller.toggleSearch(); // Toggle de l'état de recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Liste des utilisateurs filtrés
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    title: Text(user.name),
                    onTap: () {
                      // Lorsque l'utilisateur clique sur un autre utilisateur, naviguer vers son profil
                      Get.to(UserProfilePage(user: user));  // Utilisation de GetX pour la navigation
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
