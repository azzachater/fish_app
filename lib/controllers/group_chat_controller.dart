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

  // Observables
  final RxList<User> selectedUsers = <User>[].obs;
  final RxList<User> filteredUsers = <User>[].obs;
  final RxList<GroupConversation> allGroups = <GroupConversation>[].obs;
  final RxList<GroupMessage> groupMessages = <GroupMessage>[].obs;
  final RxString searchQuery = ''.obs;

  // Unread counts
  final RxMap<int, int> unreadCounts = <int, int>{}.obs;

  // Controllers
  final TextEditingController searchController = TextEditingController();

  // Getters
  User get currentUser => _userController.currentUser.value!;
  
  List<GroupConversation> get filteredGroups {
    final sorted = allGroups.toList()
      ..sort((a, b) {
        final aLast = a.messages.isNotEmpty ? a.messages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);
        final bLast = b.messages.isNotEmpty ? b.messages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);
        return bLast.compareTo(aLast);
      });
    return sorted.take(3).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    await loadAllUsers();
    await loadGroupChats();
  }

  Future<void> loadAllUsers() async {
    try {
      if (_userController.allUsers.isEmpty) {
        await _userController.fetchAllUsers();
      }
      filteredUsers.assignAll(_userController.allUsers);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: ${e.toString()}');
    }
  }

  Future<void> loadGroupChats() async {
    try {
      final groups = await _apiGroupChatService.getMyGroups();
      allGroups.assignAll(groups);

      for (final group in groups) {
        await _loadMessagesForGroup(group.id);
        _associateMessagesToGroup(group.id);
        await loadUnreadCount(group.id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load groups: ${e.toString()}');
    }
  }

  Future<void> _loadMessagesForGroup(int groupId) async {
    try {
      final messages = await _apiGroupChatService.getGroupMessages(groupId);
      // Trier les messages par date croissante
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      groupMessages.removeWhere((msg) => msg.groupConversationId == groupId);
      groupMessages.addAll(messages);
      _associateMessagesToGroup(groupId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages for group $groupId');
    }
  }

  void _associateMessagesToGroup(int groupId) {
    final group = allGroups.firstWhere((g) => g.id == groupId);
    final messagesForGroup = groupMessages
        .where((m) => m.groupConversationId == groupId)
        .toList();
    group.messages = messagesForGroup;
  }

  Future<void> loadUnreadCount(int groupId) async {
    try {
      final count = await _apiGroupChatService.getGroupUnreadCount(groupId);
      unreadCounts[groupId] = count;
    } catch (e) {
      print('Error loading unread count for group $groupId: $e');
    }
  }

  int getUnreadCountForGroup(int groupId) {
    return unreadCounts[groupId] ?? 0;
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(_userController.allUsers);
    } else {
      filteredUsers.assignAll(
        _userController.allUsers.where(
          (user) => user.name.toLowerCase().contains(query.toLowerCase())
        ).toList()
      );
    }
  }

  List<GroupConversation> _filterGroups() {
    if (searchQuery.isEmpty) return allGroups;
    return allGroups.where(
      (group) => group.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  Future<void> createGroup(String name, String avatar, List<int> memberIds) async {
    try {
      final newGroup = await _apiGroupChatService.createGroup(
        name,
        avatar,
        memberIds,
      );
      allGroups.insert(0, newGroup);
      selectedUsers.clear();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group: ${e.toString()}');
    }
  }

  Future<void> sendMessage(int groupId, String content) async {
    if (content.trim().isEmpty) return;

    try {
      await _apiGroupChatService.sendGroupMessage(
        groupId,
        content,
        currentUser.id,
      );
      await _loadMessagesForGroup(groupId);
      await loadUnreadCount(groupId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
    }
  }

  Future<void> addUserToGroup(int groupId, int userId) async {
    try {
      await _apiGroupChatService.addUserToGroup(groupId, userId);
      await loadGroupChats();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add user to group: ${e.toString()}');
    }
  }

  Future<void> markMessagesAsRead(int groupId) async {
    try {
      await _apiGroupChatService.markGroupMessagesAsRead(groupId);
      final group = allGroups.firstWhere((g) => g.id == groupId);
      for (var message in group.messages) {
        if (!message.isReadBy.contains(currentUser.id)) {
          message.isReadBy.add(currentUser.id);
        }
      }
      unreadCounts[groupId] = 0;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark messages as read: ${e.toString()}');
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