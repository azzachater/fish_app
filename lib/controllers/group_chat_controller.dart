import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../models/user_model.dart';
import '../../models/group_message_model.dart';
import '../../models/group_conversation_model.dart';
import '../services/api_groupChat_service.dart';
import '../controllers/user_controller.dart';
import '../../services/api_push_notif_service.dart';

class GroupChatController extends GetxController {
  final ApiGroupChatService _apiGroupChatService = ApiGroupChatService();
  final UserController _userController = Get.find<UserController>();
  final PusherService _pusherService = Get.find<PusherService>();

  // Observables
  final RxList<User> selectedUsers = <User>[].obs;
  final RxList<User> filteredUsers = <User>[].obs;
  final RxList<GroupConversation> allGroups = <GroupConversation>[].obs;
  final RxList<GroupMessage> groupMessages = <GroupMessage>[].obs;
  final RxString searchQuery = ''.obs;

  // Unread counts
  final RxMap<int, int> unreadCounts = <int, int>{}.obs;
  RxInt currentGroupId = 0.obs;
  final Map<int, String> _activeChannels = {};

  // Controllers
  final TextEditingController searchController = TextEditingController();

  // Getters
  User get currentUser => _userController.currentUser.value!;
  
  List<GroupConversation> get filteredGroups {
    final groups = allGroups.toList();
    groups.sort((a, b) {
      final aLast = a.messages.isNotEmpty ? a.messages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);
      final bLast = b.messages.isNotEmpty ? b.messages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);
      return bLast.compareTo(aLast);
    });
    return groups.take(3).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _setupPusher();
  }

  @override
  void onClose() {
    searchController.dispose();
    _cleanupPusher();
    super.onClose();
  }

  void _setupPusher() {
    _pusherService.addEventHandler('group_chat_events', _handlePusherEvent);
  }

  void _cleanupPusher() {
    _pusherService.removeEventHandler('group_chat_events');
    // Désabonner de tous les canaux actifs
    _activeChannels.forEach((groupId, channel) async {
      await _pusherService.unsubscribeFromChannel(channel);
    });
  }

  void _handlePusherEvent(PusherEvent event) {
    debugPrint('📡 [GroupChat] Event received [${event.channelName}] - ${event.eventName}');
    
    if (event.eventName == 'new-group-message' &&
        event.channelName.startsWith('private-group.group.') &&
        event.data != null) {
      try {
        final data = jsonDecode(event.data!);
        
        if (data['group_conversation_id'] == null || data['id'] == null) {
          return;
        }

        final newMessage = GroupMessage(
          id: data['id'],
          content: data['content'] ?? '',
          senderId: data['sender']['id'],
          sender: User(
            id: data['sender']['id'],
            name: data['sender']['name'] ?? 'Inconnu',
            avatar: data['sender']['avatar'] ?? '', 
            email: '', 
            bio: '',
          ),
          groupConversationId: data['group_conversation_id'],
          createdAt: DateTime.parse(data['created_at']), 
          isReadBy: [],
        );

        final groupId = newMessage.groupConversationId;
        
        if (!groupMessages.any((m) => m.id == newMessage.id)) {
          groupMessages.add(newMessage);
          
          final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
          if (groupIndex != -1) {
            allGroups[groupIndex].messages.add(newMessage);
          }
          
          groupMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          update(['group_messages_$groupId']);
        }
      } catch (e, stack) {
        debugPrint('❌ Error processing group message: $e');
        debugPrint('Stack trace: $stack');
      }
    }
  }

  Future<void> subscribeToGroupChannel(int groupId) async {
    final channelName = 'private-group.group.$groupId';
    currentGroupId.value = groupId;
    
    if (_activeChannels[groupId] == channelName) {
      return;
    }

    try {
      // Désabonner de l'ancien canal si existe
      if (_activeChannels.containsKey(groupId)) {
        await _pusherService.unsubscribeFromChannel(_activeChannels[groupId]!);
        _activeChannels.remove(groupId);
      }

      await _pusherService.subscribeToChannel(channelName);
      _activeChannels[groupId] = channelName;
    } catch (e) {
      debugPrint("❌ Error subscribing to group channel: $e");
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

  Future<void> _loadMessagesForGroup(int groupId) async {
    try {
      final messages = await _apiGroupChatService.getGroupMessages(groupId);
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      groupMessages.removeWhere((msg) => msg.groupConversationId == groupId);
      groupMessages.addAll(messages);
      groupMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
      if (groupIndex != -1) {
        allGroups[groupIndex].messages = messages;
      }

      update(['group_messages_$groupId']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages for group $groupId');
    }
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
        await subscribeToGroupChannel(group.id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load groups: ${e.toString()}');
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
      debugPrint('Error loading unread count for group $groupId: $e');
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

  void resetSelectedUsers() {
    selectedUsers.clear();
  }
}