import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_chat_controller.dart';
import '../../constants/theme.dart';
import '../../screens/chat/group_chat_page.dart';
import 'dart:io';
import '../../models/group_conversation_model.dart';

class AllGroups extends StatelessWidget {
  final GroupChatController controller = Get.find();

  AllGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text('All Groups', style: AppTheme.heading2),
            ],
          ),
        ),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.allGroups.length,
          itemBuilder: (context, index) {
            final group = controller.allGroups[index];
            
            // Gestion de l'image d'avatar
            ImageProvider avatarImage;
            try {
              avatarImage = group.avatar.startsWith('http')
                  ? NetworkImage(group.avatar)
                  : group.avatar.startsWith('/')
                      ? FileImage(File(group.avatar))
                      : AssetImage(group.avatar);
            } catch (e) {
              avatarImage = const AssetImage('assets/images/default_group_avatar.png');
            }

            // Dernier message ou info par défaut
            final lastMessage = group.messages.isNotEmpty 
                ? group.messages.last 
                : null;
            final lastMessageText = lastMessage?.content ?? 'No messages yet';
            final lastMessageTime = lastMessage?.createdAt ?? DateTime.now();

            // Calcul des messages non lus (si vous voulez implémenter cette fonctionnalité)
            // Note: Ajoutez un champ isRead à votre modèle GroupMessage si nécessaire
            final unreadCount = 0; // Remplacez par votre logique de calcul

            return GestureDetector(
              onTap: () {
                controller.markGroupAsRead(group);
                Get.to(() => GroupChatPage(group: group));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: avatarImage as ImageProvider<Object>?,
                  onBackgroundImageError: (_, __) {},
                ),
                title: Text(group.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lastMessageText,
                      style: AppTheme.bodyText1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${group.members.length} members',
                      style: AppTheme.bodyText1.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${lastMessageTime.hour}:${lastMessageTime.minute.toString().padLeft(2, '0')}',
                      style: AppTheme.bodyTextTime,
                    ),
                    const SizedBox(height: 4),
                    if (unreadCount > 0)
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: AppTheme.unreadChatBG,
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        )),
      ],
    );
  }
}