import 'package:fish_app/models/user_model.dart';

class Event {
  final String? id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  List<EventParticipant> participants;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    List<EventParticipant>? participants,
  }) : participants = participants ?? [];

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: DateTime.parse(json['date'].toString()),
      participants: (json['participants'] as List?)
          ?.map((p) => EventParticipant.fromJson(p))
          .toList() ?? [],
    );
  }
}

class EventParticipant {
  final String userId;
  final User user;

  EventParticipant({
    required this.userId,
    required this.user,
  });

  factory EventParticipant.fromJson(Map<String, dynamic> json) {
    return EventParticipant(
      userId: json['user_id']?.toString() ?? '',
      user: User.fromJson({
        'id': json['user_id'] ?? 0, // Utilise user_id comme fallback
        ...?json['user'], // Spread operator pour les données user complètes
      }),
    );
  }
}