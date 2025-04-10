import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/group_message_model.dart';
import '../../models/group_conversation_model.dart';
import '../services/api_groupChat_service.dart';
import '../controllers/user_controller.dart';

class GroupChatController extends GetxController {
  final ApiGroupChatService _apiGroupChatService = ApiGroupChatService();
  final UserController _userController = Get.find<UserController>();
  late User currentUser;

  var selectedUsers = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var allGroups = <GroupConversation>[].obs;
  var recentGroups = <GroupConversation>[].obs;
  var groupMessages = <GroupMessage>[].obs;
  var searchQuery = ''.obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currentUser = _userController.currentUser.value!;
    loadGroupChats();
    loadUsers();
  }
void loadUsers() {
  // Ajoute l'utilisateur courant à la liste des utilisateurs sélectionnés par défaut
  selectedUsers.add(currentUser);
  filteredUsers.assignAll(_userController.allUsers);
}

  // Update the filteredGroups getter to be observable
  List<GroupConversation> get filteredGroups {
    if (searchQuery.isEmpty) {
      return allGroups;
    }
    return allGroups.where((group) =>
        group.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  // Filter users based on the search query
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(_userController.allUsers);
    } else {
      filteredUsers.assignAll(_userController.allUsers.where((user) => 
        user.name.toLowerCase().contains(query.toLowerCase())));
    }
  }


  Future<void> loadGroupChats() async {
    try {
      final groups = await _apiGroupChatService.getMyGroups();
      allGroups.assignAll(groups);
      recentGroups.assignAll(groups.take(3).toList());
      await loadGroupMessages();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load groups');
    }
  }

  Future<void> loadGroupMessages() async {
    try {
      for (var group in allGroups) {
        final messages = await _apiGroupChatService.getGroupMessages(group.id);
        groupMessages.addAll(messages);
        _associateMessagesToGroups();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  
  /*List<GroupConversation> get filteredGroups {
  if (searchQuery.isEmpty) {
    return groups;
  }
  return groups.where((group) =>
      group.name.toLowerCase().contains(searchQuery.toLowerCase())
  ).toList();
}
*/

  void _associateMessagesToGroups() {
    for (var group in allGroups) {
      group.messages = groupMessages
          .where((message) => message.groupConversationId == group.id)
          .toList();
    }
    for (var group in recentGroups) {
      group.messages = groupMessages
          .where((message) => message.groupConversationId == group.id)
          .toList();
    }
  }

  void addUsersToGroup(GroupConversation group) {
    group.members.addAll(selectedUsers);
  }

  Future<void> sendGroupMessage(String text, int groupId) async {
    if (text.trim().isEmpty) return;

    try {
      final newMessage = GroupMessage(
        id: 0, // Temporary ID, will be replaced by server
        content: text,
        senderId: currentUser.id,
        sender: currentUser,
        groupConversationId: groupId,
        createdAt: DateTime.now(),
      );

      await _apiGroupChatService.sendGroupMessage(groupId, text, currentUser.id);
      groupMessages.add(newMessage);
      _updateGroups(groupId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  void _updateGroups(int groupId) {
    final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      allGroups[groupIndex].messages.insert(0, 
        groupMessages.firstWhere((m) => m.groupConversationId == groupId));
    }

    final recentIndex = recentGroups.indexWhere((g) => g.id == groupId);
    if (recentIndex == -1) {
      final group = allGroups.firstWhere((g) => g.id == groupId);
      recentGroups.insert(0, group);
    } else {
      final group = recentGroups.removeAt(recentIndex);
      recentGroups.insert(0, group);
    }
  }

  void markGroupAsRead(GroupConversation group) {
    // You'll need to implement this based on your actual GroupConversation model
    // This is just a placeholder
    final updatedGroup = group; // Implement your copyWith method if needed

    final allIndex = allGroups.indexWhere((g) => g.id == group.id);
    if (allIndex != -1) allGroups[allIndex] = updatedGroup;

    final recentIndex = recentGroups.indexWhere((g) => g.id == group.id);
    if (recentIndex != -1) recentGroups[recentIndex] = updatedGroup;
  }

  Future<void> addGroup(String name, String avatar, List<int> memberIds) async {
    try {
      final newGroup = await _apiGroupChatService.createGroup(name, avatar, memberIds);
      allGroups.add(newGroup);
      recentGroups.insert(0, newGroup);
      selectedUsers.clear();
      selectedUsers.add(currentUser);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group');
    }
  }

  void toggleUserSelection(User user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
  }
}