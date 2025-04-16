class Event {
  final String? id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  List<String> participants; // Retirez 'final' et le '?'

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    List<String>? participants, // Gardez le '?' pour le paramètre optionnel
  }) : participants =
           participants ?? []; // Initialisation avec opérateur null-aware

  factory Event.fromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id']?.toString(),
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    location: json['location'] ?? '',
    date: DateTime.parse(json['date'].toString()), // Force le parsing
    participants: List<String>.from(json['participants'] ?? []),
  );
}

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'participants': participants,
    };
  }
}
