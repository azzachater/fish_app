import './user_model.dart';

class Message {
  final User sender;
  final User? receiver; // Pour les conversations individuelles
  final String? groupId; // Pour les conversations de groupe
  final String avatar;
  final String time;
  final String text;
  final int unreadCount;
  final bool isRead;

  Message({
    required this.sender,
    this.receiver,
    this.groupId,
    required this.avatar,
    required this.text,
    required this.time,
    this.unreadCount = 0,
    this.isRead = false,
  });

  // Méthode copyWith
  Message copyWith({
    User? sender,
    User? receiver,
    String? groupId,
    String? avatar,
    String? time,
    String? text,
    int? unreadCount,
    bool? isRead,
  }) {
    return Message(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      groupId: groupId ?? this.groupId,
      avatar: avatar ?? this.avatar,
      time: time ?? this.time,
      text: text ?? this.text,
      unreadCount: unreadCount ?? this.unreadCount,
      isRead: isRead ?? this.isRead,
    );
  }
}