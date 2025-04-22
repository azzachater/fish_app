import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../../models/conversation_model.dart';
import '../../models/user_model.dart';
import '../../services/api_chat_service.dart';
import '../../services/api_user_service.dart';
import '../../service/api_auth_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ChatController extends GetxController {
  final ApiChatService _apiChatService = ApiChatService();
  final ApiUserService _apiUserService = ApiUserService();
  final ApiAuthService _apiAuthService = ApiAuthService();

  var conversations = <Conversation>[].obs;
  var conversationMessages = <Message>[].obs;
  var filteredUsers = <User>[].obs;
  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var allUsers = <User>[].obs;
  var unreadCounts = <int, int>{}.obs;
  RxInt currentConversationId = 0.obs;
  Map<int, String> activeChannels = {};  // Suivi des canaux actifs


  late PusherChannelsFlutter pusher;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadAllUsers();
    loadConversations();
    initPusher(); // <-- ici
  }

   // Initialisation de Pusher
  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    await pusher.init(
      apiKey: '2798f826b9ce70d037b5',
      cluster: 'eu',
      authEndpoint: 'http://10.0.2.2:8000/api/broadcasting/auth',
      onAuthorizer: (channelName, socketId, options) async {
        return await buildChannelAuthorizer(channelName, socketId);
      },
      onConnectionStateChange: (currentState, previousState) {
        print("🔌 Connexion: $previousState => $currentState");
      },
      onError: (message, code, exception) {
        print("❌ Erreur: $message");
      },
    );

    await pusher.connect();
  }

  // Authentificateur de canal privé
  Future<String> buildChannelAuthorizer(String channelName, String socketId) async {
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
      return response.body;
    } else {
      throw Exception('Erreur d’authentification : ${response.statusCode}');
    }
  }

  // Souscrire au canal de conversation
  Future<void> subscribeToConversationChannel(int conversationId) async {
    //String channel = 'private-chat.chat.$conversationId';
    currentConversationId.value = conversationId;
    await pusher.subscribe(channelName: 'private-chat.chat.$conversationId');

  pusher.onEvent = (PusherEvent event) {
  print("📡 [onEvent] ${event.channelName} - ${event.eventName}: ${event.data}");

  if (event.eventName == 'new-message' && event.data != null) {
    final data = jsonDecode(event.data!);

    final newMessage = Message(
      id: data['id'],
      content: data['content'],
      createdAt: DateTime.parse(data['created_at']),
      sender: User(
        id: data['sender_id'],
        name: 'Unknown', // Récupère le nom si disponible
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
  }
};

  }

 /* // Gestion des événements Pusher
  void _handlePusherEvent(PusherEvent event) {
    print('📡 [onEvent] ${event.channelName} - ${event.eventName} => ${event.data}');

    if (event.eventName == 'new-message' && event.data != null) {
      final data = jsonDecode(event.data!);

      final newMessage = Message(
        id: data['id'],
        content: data['content'],
        createdAt: DateTime.parse(data['created_at']),
        sender: User(
          id: data['sender_id'],
          name: 'Unknown', // Tu peux récupérer le nom si dispo
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
    }
  }
*/
  // Envoyer un message
  Future<void> sendMessage(String content, int receiverId) async {
    try {
      isLoading(true);

      final response = await _apiChatService.sendMessage(receiverId, content);

      if (response.containsKey('data')) {
        //conversationMessages.insert(0, serverMessage);
        await loadConversations();
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi du message: $e');
      Get.snackbar('Erreur', 'Échec de l\'envoi du message');
    } finally {
      isLoading(false);
    }
  }

  //reste de code 
  
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

    print("✅ Raw data type: ${data.runtimeType}");
    print("✅ Data content: $data");

    conversations.assignAll(data.map((json) {
      try {
        return Conversation.fromJson(json is Map ? Map<String, dynamic>.from(json) : {});
      } catch (e) {
        print('❌ Error parsing individual conversation: $e');
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
    print('❌ Detailed error: $e');
    print('❌ Stack trace: ${e is Error ? e.stackTrace : ''}');
    Get.snackbar('Error', 'Failed to load conversations: ${e.toString()}');
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