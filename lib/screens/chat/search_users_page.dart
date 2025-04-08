import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/chat/chat_room.dart';
import '../../constants/theme.dart';
import '../../controllers/chat_controller.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  late TextEditingController searchController;
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    // Réinitialiser la recherche quand on arrive sur la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.filterUsers('');
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    // Réinitialiser la recherche quand on quitte la page
    chatController.filterUsers('');
    super.dispose();
  }

  ImageProvider _buildImageProvider(String avatarPath) {
    if (avatarPath.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (avatarPath.startsWith('http')) {
      return NetworkImage(avatarPath);
    } else if (avatarPath.startsWith('assets/')) {
      return AssetImage(avatarPath);
    } else {
      return FileImage(File(avatarPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            chatController.filterUsers(value);
          },
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatController.filteredUsers.isEmpty) {
          return Center(
            child: Text(
              searchController.text.isEmpty
                  ? 'No users available'
                  : 'No users found for "${searchController.text}"',
              style: AppTheme.heading2,
            ),
          );
        }

        return ListView.builder(
          itemCount: chatController.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = chatController.filteredUsers[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12, 
                horizontal: 16,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: _buildImageProvider(user.avatar),
              ),
              title: Text(
                user.name,
                style: AppTheme.heading2.copyWith(fontSize: 16),
              ),
              onTap: () {
                Get.to(() => ChatRoom(user: user));
              },
            );
          },
        );
      }),
    );
  }
}