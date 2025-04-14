import 'package:fish_app/services/api_auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/group_message_model.dart';
import '../../models/group_conversation_model.dart';
import '../services/api_groupChat_service.dart';
import '../controllers/user_controller.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupChatController extends GetxController {
  final ApiGroupChatService _apiGroupChatService = ApiGroupChatService();
  final UserController _userController = Get.find<UserController>();
  final ApiAuthService _apiAuthService = ApiAuthService();

  // Observables
  final RxList<User> selectedUsers = <User>[].obs;
  final RxList<User> filteredUsers = <User>[].obs;
  final RxList<GroupConversation> allGroups = <GroupConversation>[].obs;
  final RxList<GroupMessage> groupMessages = <GroupMessage>[].obs;
  final RxString searchQuery = ''.obs;

  // Unread counts
  final RxMap<int, int> unreadCounts = <int, int>{}.obs;

  late PusherChannelsFlutter pusher;
  RxInt currentGroupId = 0.obs;
  final Map<int, String> _activeChannels = {};

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
    initPusher();
  }

  @override
  void onClose() {
    searchController.dispose();
    disconnectPusher();
    super.onClose();
  }

  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: '2798f826b9ce70d037b5',
        cluster: 'eu',
        authEndpoint: 'http://10.0.2.2:8000/api/broadcasting/auth',
        onAuthorizer: (channelName, socketId, options) async {
          return await _buildChannelAuthorizer(channelName, socketId);
        },
        onConnectionStateChange: (current, previous) {
          debugPrint("🔌 Pusher Group: $previous ➜ $current");
        },
        onError: (message, code, exception) {
          debugPrint("❌ Pusher Error: $message (code: $code)");
          if (exception != null) debugPrint("Exception: $exception");
        },
      );

      pusher.onEvent = _handlePusherEvent;
      await pusher.connect();
      debugPrint("🟢 Pusher connecté avec succès");
    } catch (e) {
      debugPrint("❌ Erreur d'initialisation Pusher: $e");
    }
  }

  // Authentification du canal privé
  Future<Map<String, dynamic>> _buildChannelAuthorizer(String channelName, String socketId) async {
    debugPrint("🛂 Channel: $channelName, Socket: $socketId");
    try {
      final token = await _apiAuthService.getToken();
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/broadcasting/auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'channel_name': channelName,
          'socket_id': socketId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur auth : ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Erreur d'authentification: $e");
      rethrow;
    }
  }

  // Gérer les événements Pusher
  void _handlePusherEvent(PusherEvent event) {
  debugPrint('📡 [onEvent] ${event.channelName} - ${event.eventName}');
  debugPrint('Data received: ${event.data}'); // Ajouté pour le débogage
  
  if (event.eventName == 'new-group-message' &&
      event.channelName?.startsWith('private-group.group.') == true &&
      event.data != null) {
    try {
      final data = jsonDecode(event.data!);
      debugPrint('Decoded data: $data'); // Pour voir la structure exacte
      
      // Vérification complète des données requises
      if (data['group_conversation_id'] == null || data['id'] == null) {
        debugPrint('❌ Données manquantes dans le message');
        return;
      }

      final newMessage = GroupMessage(
        id: data['id'],
        content: data['content'] ?? '',
      senderId: data['sender']['id'],
        sender: User(
          id: data['sender']['id'],
          name: data['sender']['name'] ?? 'Inconnu',
          avatar: data['sender']['avatar'] ?? '', email: '', bio: '',
        ),
        groupConversationId: data['group_conversation_id'],
        createdAt: DateTime.parse(data['created_at']), isReadBy: [],
      );

      final groupId = newMessage.groupConversationId;
      debugPrint('Processing message for group: $groupId');

      // Vérifier si le message existe déjà
      final messageExists = groupMessages.any((m) => m.id == newMessage.id);
      
      if (!messageExists) {
        // Ajouter le message
        groupMessages.add(newMessage);
        
        // Mettre à jour le groupe spécifique
        final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
        if (groupIndex != -1) {
          allGroups[groupIndex].messages.add(newMessage);
        }
        
        // Forcer le rafraîchissement
        update(['group_messages_$groupId']);
        debugPrint('✅ Message ajouté - ID: ${newMessage.id}');
      }
    } catch (e, stack) {
      debugPrint('❌ Erreur de traitement: $e');
      debugPrint('Stack trace: $stack');
    }
  }
}
  // Souscrire à un canal de groupe
  Future<void> subscribeToGroupChannel(int groupId) async {
    final channel = 'private-group.group.$groupId';
    currentGroupId.value = groupId;
    // Ne pas se réabonner si déjà abonné
  if (_activeChannels[groupId] == channel) {
    debugPrint('⚠️ Déjà abonné à $channel');
    return;
  }

    try {
      // Désabonner l'ancien canal s'il existe
      if (_activeChannels.containsKey(groupId)) {
        await pusher.unsubscribe(channelName: _activeChannels[groupId]!);
        _activeChannels.remove(groupId);
      }

      await pusher.subscribe(channelName: channel);
      _activeChannels[groupId] = channel;

      debugPrint("✅ Abonné au canal: $channel");
    } catch (e) {
      debugPrint("❌ Erreur d'abonnement: $e");
    }
  }

 
  // Déconnexion de Pusher
  Future<void> disconnectPusher() async {
    try {
      await pusher.disconnect();
      debugPrint("🔴 Pusher déconnecté");
    } catch (e) {
      debugPrint("❌ Erreur déconnexion Pusher: $e");
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
    
    // Mettre à jour groupMessages
    groupMessages.removeWhere((msg) => msg.groupConversationId == groupId);
    groupMessages.addAll(messages);
    
    // Mettre à jour les messages du groupe
    final groupIndex = allGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      allGroups[groupIndex].messages = messages;
    }
    
    update(); // Notifier les observateurs
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

//le reste de méthodes

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