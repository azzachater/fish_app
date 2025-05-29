import 'package:intl/intl.dart';

class FishingJournal {
  final String id;
  final String title;
  final String location;
  final String speciesCaught;
  final String fishingConditions;
  final String notes;
  final String date;
  final String time;

  FishingJournal({
    required this.id,
    required this.title,
    required this.location,
    required this.speciesCaught,
    required this.fishingConditions,
    required this.notes,
    required this.date,
    required this.time,
  });

  factory FishingJournal.fromJson(Map<String, dynamic> json) {
    return FishingJournal(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Sans titre',
      location: json['location'] ?? 'Lieu non spécifié',
      speciesCaught: json['species_caught'] ?? '', // Adaptation ici
      fishingConditions: json['fishing_conditions'] ?? '', // Adaptation ici
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
      'species_caught': speciesCaught, // Adaptation ici
      'fishing_conditions': fishingConditions, // Adaptation ici
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