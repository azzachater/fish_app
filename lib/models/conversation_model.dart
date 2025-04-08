import 'message_model.dart';
import 'user_model.dart';

class Conversation {
  final int id;
  final User userOne;
  final User userTwo;
  final Message? lastMessage; // ✅ Ajouté ici
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.userOne,
    required this.userTwo,
    required this.messages,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
  if (json['messages'] == null) {
    throw Exception('Messages non trouvés dans la réponse');
  }
  try {
    return Conversation(
      id: json['id'],
      userOne: User.fromJson(json['user_one']),
      userTwo: User.fromJson(json['user_two']),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List).map((m) => Message.fromJson(m)).toList()
          : [],
    );
  } catch (e) {
    print('Erreur lors du parsing de la conversation : $e');
    rethrow;
  }
  }
}
