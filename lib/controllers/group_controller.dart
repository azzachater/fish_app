/*import 'package:get/get.dart';
import '../../models/group_model.dart';
import '../../data/group_data.dart';
import '../../models/message_model.dart';
import '../../data/message_data.dart';
import '../../data/user_data.dart';
import '../../models/user_model.dart';

class GroupController extends GetxController {
  var allGroups = <Group>[].obs;
  var recentGroups = <Group>[].obs;
  var groupMessages = <Message>[].obs;
  var allUsers = <User>[].obs; // Ajout de allUsers

  @override
  void onInit() {
    super.onInit();
    loadGroupChats();
    loadUsers();  // Assure que les utilisateurs sont chargés
  }

  void loadUsers() {
    allUsers.assignAll(usersData); // Assigne les utilisateurs au controller
  }

  void loadGroupChats() {
    allGroups.assignAll(allGroupsData);
    recentGroups.assignAll(recentGroupsData);
    groupMessages.assignAll(groupMessagesData);
    _associateMessagesToGroups();
  }

  void _associateMessagesToGroups() {
    for (var group in allGroups) {
      group.messages = groupMessages
          .where((message) => message.groupId == group.id)
          .toList();
    }
    for (var group in recentGroups) {
      group.messages = groupMessages
          .where((message) => message.groupId == group.id)
          .toList();
    }
  }

  void sendGroupMessage(String text, String groupId) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      sender: currentUser,
      groupId: groupId,
      avatar: currentUser.avatar,
      text: text,
      time: 'Now',
      unreadCount: 0,
      isRead: true,
    );

    // Ajouter le message à la liste globale
    groupMessages.add(newMessage);
    groupMessagesData.add(newMessage);

    // Mettre à jour les groupes
    _updateGroups(groupId);

    update();
  }

  void _updateGroups(String groupId) {
    final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      allGroups[groupIndex].messages.insert(0, 
        groupMessages.firstWhere((m) => m.groupId == groupId));
    }

    final recentIndex = recentGroups.indexWhere((g) => g.id == groupId);
    if (recentIndex == -1) {
      // Si le groupe n'est pas dans les récents, l'ajouter
      final group = allGroups.firstWhere((g) => g.id == groupId);
      recentGroups.insert(0, group);
    } else {
      // Sinon, mettre à jour la position
      final group = recentGroups.removeAt(recentIndex);
      recentGroups.insert(0, group);
    }
  }

  void markGroupAsRead(Group group) {
    final updatedGroup = group.copyWith(isRead: true, unreadCount: 0);
    
    final allIndex = allGroups.indexWhere((g) => g.id == group.id);
    if (allIndex != -1) allGroups[allIndex] = updatedGroup;

    final recentIndex = recentGroups.indexWhere((g) => g.id == group.id);
    if (recentIndex != -1) recentGroups[recentIndex] = updatedGroup;

    update();
  }

  void addUsersToGroup(Group group, List<User> users) {
    group.members.addAll(users);  // Ajouter les utilisateurs au groupe
    update();  // Met à jour l'interface utilisateur
  }
}
*/