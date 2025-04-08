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

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadAllUsers();
    loadConversations();
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
      
      final json = await _apiChatService.getMessages(conversationId);
      
      if (json.containsKey('message') && json['message'] == 'Record not found.') {
        conversationMessages.assignAll([]);
        return;
      }
      
      if (json.containsKey('messages') && json['messages'] is List) {
        final messages = (json['messages'] as List)
            .map((msgJson) => Message.fromJson(msgJson))
            .toList();
        conversationMessages.assignAll(messages.reversed);
      } else {
        throw Exception('Invalid messages format');
      }
    } catch (e) {
      print('Error loading messages: $e');
      Get.snackbar('Error', 'Failed to load messages');
      conversationMessages.assignAll([]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendMessage(String content, int receiverId) async {
  try {
    isLoading(true);
    
    // Send to server and wait for response
    final response = await _apiChatService.sendMessage(receiverId, content);
    
    // Safely handle the response
    if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      final messageData = response['data'] as Map<String, dynamic>;
      
      // Ensure the message is attributed to current user
      final serverMessage = Message(
        id: messageData['id'] as int,
        content: messageData['content'] as String,
        createdAt: DateTime.parse(messageData['created_at'] as String),
        isRead: false,
        sender: currentUser.value!, // Force current user as sender
      );
      
      conversationMessages.insert(0, serverMessage);
      
      // Update conversations list
      await loadConversations();
    } else {
      throw Exception('Invalid message data format');
    }
    
  } catch (e) {
    print('Error sending message: $e');
    Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
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
}