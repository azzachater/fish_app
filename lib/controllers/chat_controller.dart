import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../models/message_model.dart';
import '../../models/conversation_model.dart';
import '../../models/user_model.dart';
import '../../services/api_chat_service.dart';
import '../../services/api_user_service.dart';
import '../../services/api_push_notif_service.dart';

class ChatController extends GetxController {
  final ApiChatService _apiChatService = ApiChatService();
  final ApiUserService _apiUserService = ApiUserService();
  final PusherService _pusherService = Get.find<PusherService>();

  // Observables
  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxList<Message> conversationMessages = <Message>[].obs;
  final RxList<User> filteredUsers = <User>[].obs;
  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxList<User> allUsers = <User>[].obs;
  final RxMap<int, int> unreadCounts = <int, int>{}.obs;
  final RxInt currentConversationId = 0.obs;
  final Map<int, String> _activeChannels = {};

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadAllUsers();
    loadConversations();
    _setupPusher();
  }

  @override
  void onClose() {
    _cleanupPusher();
    super.onClose();
  }

  void _setupPusher() {
    _pusherService.addEventHandler('chat_events', _handlePusherEvent);
  }

  void _cleanupPusher() {
    _pusherService.removeEventHandler('chat_events');
    // Désabonner de tous les canaux actifs
    _activeChannels.forEach((conversationId, channel) async {
      await _pusherService.unsubscribeFromChannel(channel);
    });
  }

  void _handlePusherEvent(PusherEvent event) {
    print('📡 [Chat] Event received [${event.channelName}] - ${event.eventName}');
    
    if (event.eventName == 'new-message' && 
        event.channelName.startsWith('private-chat.chat.') &&
        event.data != null) {
      try {
        final data = jsonDecode(event.data!);
        
        final newMessage = Message(
          id: data['id'],
          content: data['content'],
          createdAt: DateTime.parse(data['created_at']),
          sender: User(
            id: data['sender_id'],
            name: 'Unknown',
            email: '',
            avatar: '',
            bio: '',
          ),
          isRead: false,
        );

        if (currentConversationId.value == data['conversation_id'] &&
            !conversationMessages.any((m) => m.id == newMessage.id)) {
          conversationMessages.insert(0, newMessage);
        }
      } catch (e) {
        print('❌ Error processing message: $e');
      }
    }
  }

  Future<void> subscribeToConversationChannel(int conversationId) async {
    final channelName = 'private-chat.chat.$conversationId';
    currentConversationId.value = conversationId;
    
    if (_activeChannels[conversationId] == channelName) {
      return;
    }

    try {
      // Désabonner de l'ancien canal si existe
      if (_activeChannels.containsKey(conversationId)) {
        await _pusherService.unsubscribeFromChannel(_activeChannels[conversationId]!);
        _activeChannels.remove(conversationId);
      }

      await _pusherService.subscribeToChannel(channelName);
      _activeChannels[conversationId] = channelName;
    } catch (e) {
      print('❌ Error subscribing to conversation channel: $e');
    }
  }

  Future<void> sendMessage(String content, int receiverId) async {
    try {
      isLoading(true);
      final response = await _apiChatService.sendMessage(receiverId, content);

      if (response.containsKey('data')) {
        await loadConversations();
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isLoading(false);
    }
  }

  // ... (les autres méthodes restent inchangées)
  
  List<Conversation> get sortedConversations {
    return conversations.toList()
      ..sort((a, b) {
        final aDate = a.lastMessage?.createdAt ?? DateTime(0);
        final bDate = b.lastMessage?.createdAt ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
  }

  List<Conversation> get recentConversations {
    final sorted = sortedConversations;
    return sorted.length <= 3 ? sorted : sorted.sublist(0, 3);
  }

  Future<void> loadCurrentUser() async {
    try {
      isLoading(true);
      currentUser.value = await _apiUserService.getCurrentUser();
    } catch (e) {
      print('Error loading current user: $e');
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAllUsers() async {
    try {
      isLoading(true);
      final users = await _apiUserService.getAllUsers();
      allUsers.assignAll(users);
      filteredUsers.assignAll(
        users.where((u) => u.id != currentUser.value?.id).toSet().toList()
      );
    } catch (e) {
      print('Error loading all users: $e');
      Get.snackbar('Error', 'Failed to load users');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadConversations() async {
    try {
      isLoading(true);
      final data = await _apiChatService.getMyConversations();

      conversations.assignAll(data.map((json) {
        try {
          return Conversation.fromJson(json is Map ? Map<String, dynamic>.from(json) : {});
        } catch (e) {
          print('❌ Error parsing conversation: $e');
          return Conversation(
            id: 0,
            userOne: User.empty(),
            userTwo: User.empty(),
          );
        }
      }).where((conv) => conv.id != 0).toList());

      for (var conv in conversations) {
        unreadCounts[conv.id] = conv.unreadCount;
      }
    } catch (e) {
      print('❌ Error loading conversations: $e');
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMessages(int conversationId) async {
    try {
      isLoading(true);
      conversationMessages.clear();
      
      await _markMessagesAsRead(conversationId);
      
      final json = await _apiChatService.getMessages(conversationId);
      
      if (json.containsKey('messages') && json['messages'] is List) {
        final messages = (json['messages'] as List)
            .map((msgJson) => Message.fromJson(msgJson))
            .toList();
            
        conversationMessages.assignAll(messages.reversed);
        unreadCounts[conversationId] = 0;
        update();
      }
    } catch (e) {
      print('Error loading messages: $e');
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _markMessagesAsRead(int conversationId) async {
    try {
      await _apiChatService.markMessagesAsRead(conversationId);
      unreadCounts[conversationId] = 0;
      
      for (var msg in conversationMessages) {
        if (msg.sender.id != currentUser.value?.id) {
          msg.isRead = true;
        }
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(allUsers.where((u) => u.id != currentUser.value?.id));
    } else {
      filteredUsers.assignAll(allUsers.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) && 
               user.id != currentUser.value?.id;
      }));
    }
  }

  User getOtherUser(Conversation conversation) {
    if (conversation.userOne.id == currentUser.value?.id) {
      return conversation.userTwo;
    }
    return conversation.userOne;
  }

  int getUnreadCountForConversation(int conversationId) {
    return unreadCounts[conversationId] ?? 0;
  }
}