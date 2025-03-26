import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../../data/message_data.dart';
import '../../models/user_model.dart';
import '../../data/user_data.dart';

class ChatController extends GetxController {
  var allChats = <Message>[].obs;
  var recentChats = <Message>[].obs;
  var conversationMessages = <Message>[].obs;
  var filteredUsers = <User>[].obs;

  @override
  void onInit() {
    loadChats();
    super.onInit();
  }

  @override
  void onClose() {
    // Réinitialiser la liste des utilisateurs filtrés quand on quitte la page
    filteredUsers.clear();
    super.onClose();
  }

  void loadChats() {
    allChats.assignAll(allChatsData);
    recentChats.assignAll(recentChatsData);
  }

  void loadMessages(int userId) {
    final messages = messagesData.where((message) =>
        (message.sender.id == currentUser.id && message.receiver?.id == userId) ||
        (message.receiver?.id == currentUser.id && message.sender.id == userId)
    ).toList();
  conversationMessages.assignAll(messages);
     
  }

  void filterUsers(String query) {
    final List<User> results = usersData.where((user) {
      final String userName = user.name.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return userName.contains(searchQuery);
    }).toList();
    filteredUsers.assignAll(results); // Mettre à jour la liste filtrée
  }

  void markMessageAsRead(int index, bool isRecent) {
    if (isRecent) {
      recentChats[index] = recentChats[index].copyWith(isRead: true, unreadCount: 0);
    } else {
      allChats[index] = allChats[index].copyWith(isRead: true, unreadCount: 0);
    }
  }

  void sendMessage(String text, User receiver) {
    final newMessage = Message(
      sender: currentUser,
      receiver: receiver,
      text: text,
      time: 'Now', // Remplacer par l'heure réelle
      avatar: 'assets/images/users/you.png',
      unreadCount: 1,
      isRead: false,
    );

    conversationMessages.insert(0,newMessage);
  }
}
