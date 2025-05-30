import 'package:intl/intl.dart';

class FishingJournal {
  final String id;
  final String title;
  final String location;
  // ignore: non_constant_identifier_names
  final String species_caught;
  // ignore: non_constant_identifier_names
  final String fishing_conditions;
  final String notes;
  final String date;
  final String time;

  FishingJournal({
    required this.id,
    required this.title,
    required this.location,
    // ignore: non_constant_identifier_names
    required this.species_caught,
    // ignore: non_constant_identifier_names
    required this.fishing_conditions,
    required this.notes,
    required this.date,
    required this.time,
  });

  factory FishingJournal.fromJson(Map<String, dynamic> json) {
    return FishingJournal(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Sans titre',
      location: json['location'] ?? 'Lieu non spécifié',
      species_caught: json['species_caught'] ?? '', // Adaptation ici
      fishing_conditions: json['fishing_conditions'] ?? '', // Adaptation ici
      notes: json['notes'] ?? '',
      date: json['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: json['time'] ?? '00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'species_caught': species_caught, // Adaptation ici
      'fishing_conditions': fishing_conditions, // Adaptation ici
      'notes': notes,
      'date': date,
      'time': time,
    };
  }

  String get formattedDate {
    try {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(DateFormat('yyyy-MM-dd').parse(date));
    } catch (e) {
      return date;
    }
  }

  String get formattedDateForDisplay {
    return DateFormat('EEE d').format(DateFormat('yyyy-MM-dd').parse(date));
  }

  String get formattedTimeForDisplay {
    return DateFormat('HH:mm').format(DateFormat('HH:mm').parse(time));
  }
}