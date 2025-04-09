import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../../models/conversation_model.dart';
import '../../models/user_model.dart';
import '../../services/api_chat_service.dart';
import '../../services/api_user_service.dart';

class ChatController extends GetxController {
  final ApiChatService _apiChatService = ApiChatService();
  final ApiUserService _apiUserService = ApiUserService();

  var conversations = <Conversation>[].obs;
  var conversationMessages = <Message>[].obs;
  var filteredUsers = <User>[].obs;
  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var allUsers = <User>[].obs;
  var unreadCounts = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadAllUsers();
    loadConversations();
  }

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
      conversations.assignAll(data.map((json) => Conversation.fromJson(json)));
      
      for (var conv in conversations) {
        unreadCounts[conv.id] = conv.unreadCount;
      }
    } catch (e) {
      print('Error loading conversations: $e');
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMessages(int conversationId) async {
    try {
      isLoading(true);
      conversationMessages.clear();
      
      // Marquer comme lus avant de charger
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
      
      // Mise à jour locale
      for (var msg in conversationMessages) {
        if (msg.sender.id != currentUser.value?.id) {
          msg.isRead = true;
        }
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> sendMessage(String content, int receiverId) async {
    try {
      isLoading(true);
      final response = await _apiChatService.sendMessage(receiverId, content);
      
      if (response.containsKey('data')) {
        final messageData = response['data'] as Map<String, dynamic>;
        final serverMessage = Message(
          id: messageData['id'] as int,
          content: messageData['content'] as String,
          createdAt: DateTime.parse(messageData['created_at']),
          isRead: false,
          sender: currentUser.value!,
        );
        
        conversationMessages.insert(0, serverMessage);
        await loadConversations();
      }
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isLoading(false);
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