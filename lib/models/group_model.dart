import 'user_model.dart';
import 'message_model.dart';
class Group {
  final String id;
  final String name;
  final String avatar;
  final List<User> members;
  final User admin;
  final int unreadCount;
  final bool isRead;
  final String time;
   List<Message> messages; // Add this line


  Group({
    required this.id,
    required this.name,
    required this.avatar,
    required this.members,
    required this.admin,
    required this.unreadCount,
    required this.isRead,
    required this.time,
    required this.messages, // Include this in the constructor

  });
  // Méthode copyWith
  Group copyWith({
    String? id,
    String? name,
    String? avatar,
    List<User>? members,
    User? admin,
    int? unreadCount,
    bool? isRead,
    String? time,
    List<Message>? message,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      admin: admin ?? this.admin,
      unreadCount: unreadCount ?? this.unreadCount,
      isRead: isRead ?? this.isRead,
      time: time ?? this.time,
       messages: [],
    );
  }
}

