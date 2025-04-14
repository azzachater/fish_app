import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/group_conversation_model.dart';
import '../../constants/theme.dart';
import '../../controllers/group_chat_controller.dart';
import 'dart:io';

class AddUserToGroupPage extends StatelessWidget {
  final GroupConversation group;

  const AddUserToGroupPage({super.key, required this.group});

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
    final GroupChatController controller = Get.find<GroupChatController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        // Initialisation des sélections
        if (controller.selectedUsers.isEmpty) {
          controller.selectedUsers.addAll(group.members);
          if (!controller.selectedUsers.any((u) => u.id == controller.currentUser.id)) {
            controller.selectedUsers.add(controller.currentUser);
          }
        }

        return Column(
          children: [
            // Section d'ajout
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre de recherche
                  TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: controller.filterUsers,
                  ),
                  const SizedBox(height: 16),
                  
                  // Liste des utilisateurs sélectionnables
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        final isGroupMember = group.members.any((m) => m.id == user.id);
                        final isSelected = controller.selectedUsers.any((u) => u.id == user.id);
                        final isCurrentUser = user.id == controller.currentUser.id;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: isCurrentUser || isGroupMember 
                                    ? null 
                                    : () => controller.toggleUserSelection(user),
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: _buildImageProvider(user.avatar),
                                      child: isGroupMember
                                          ? Container(
                                              color: Colors.black.withOpacity(0.4),
                                              child: const Center(
                                                child: Icon(Icons.check, color: Colors.white),
                                              ),
                                            )
                                          : null,
                                    ),
                                    if (!isGroupMember && !isCurrentUser)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppTheme.primaryColor : Colors.grey,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: Icon(
                                            isSelected ? Icons.check : Icons.add,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.name.split(' ')[0],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Bouton d'ajout
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Ajouter seulement les nouveaux membres sélectionnés
                        final newMembers = controller.selectedUsers
                            .where((user) => !group.members.any((m) => m.id == user.id))
                            .toList();
                        
                        // Appel à l'API pour chaque nouvel utilisateur
                        for (final user in newMembers) {
                          await controller.addUserToGroup(group.id, user.id);
                        }
                        
                        // Mise à jour locale
                        group.members.addAll(newMembers);
                        controller.selectedUsers.clear();
                        
                        Get.back();
                        
                        Get.snackbar(
                          'Success',
                          '${newMembers.length} members added',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: const Text('Add Members'),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Liste des membres existants
            Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text('Group Admin', style: AppTheme.subtitleStyle),
      ),
      // Afficher l'admin
      ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: _buildImageProvider(group.admin.avatar),
        ),
        title: Text(
          group.admin.name,
          style: AppTheme.heading2.copyWith(fontSize: 16, color: const Color.fromARGB(255, 24, 25, 26)),
        ),
        subtitle: Text('Admin', style: AppTheme.subtitleStyle),
        trailing: group.admin.id == controller.currentUser.id
            ? const Text('You', style: TextStyle(color: Colors.grey))
            : null,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(thickness: 1.2),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text('Group Members', style: AppTheme.subtitleStyle),
      ),
      // Liste des membres (sauf admin)
      Expanded(
        child: ListView.builder(
          itemCount: group.members.where((m) => m.id != group.admin.id).length,
          itemBuilder: (context, index) {
            final otherMembers = group.members.where((m) => m.id != group.admin.id).toList();
            final member = otherMembers[index];
            final isCurrentUser = member.id == controller.currentUser.id;

            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: _buildImageProvider(member.avatar),
              ),
              title: Text(
                member.name,
                style: AppTheme.heading2.copyWith(
                  fontSize: 16,
                  color: isCurrentUser ? AppTheme.primaryColor : null,
                ),
              ),
              subtitle: Text('Member', style: AppTheme.subtitleStyle),
              trailing: isCurrentUser
                  ? const Text('You', style: TextStyle(color: Colors.grey))
                  : null,
            );
          },
        ),
      ),
    ],
  ),
),


        ],
      );
    }),
    );
  }
}