import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/search_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_profile_page.dart';
import '../../controllers/user_controller.dart'; // <- pour currentUser

class SearchProfilePage extends StatelessWidget {
  const SearchProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProfileController controller = Get.put(
      SearchProfileController(),
    );
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(), // ou Navigator.pop(context);
        ),
        title: Obx(() {
          return controller.isSearching.value
              ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un utilisateur',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                onChanged: controller.filterUsers,
                style: const TextStyle(color: Colors.white),
              )
              : const Text(
                'Rechercher un utilisateur',
                style: TextStyle(color: Colors.white), // Texte blanc
              );
        }),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(
                controller.isSearching.value ? Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
            onPressed: controller.toggleSearch,
          ),
        ],
      ),

      body: Obx(() {
        // 🔥 Exclusion de l’utilisateur courant
        final currentUserId = userController.currentUser.value?.id;
        final usersToShow =
            controller.filteredUsers
                .where((user) => user.id != currentUserId)
                .toList();

        if (usersToShow.isEmpty) {
          return const Center(
            child: Text(
              'Aucun utilisateur trouvé',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: usersToShow.length,
          itemBuilder: (context, index) {
            final user = usersToShow[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: _getAvatarImage(user.avatar),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.to(() => UserProfilePage(user: user));
              },
            );
          },
        );
      }),
    );
  }

  ImageProvider _getAvatarImage(String? avatarUrl) {
    if (avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    }
    return const AssetImage('assets/images/default_avatar.png');
  }
}
