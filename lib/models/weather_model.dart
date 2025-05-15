class Weather {
  final String description;
  final double temperature;
  final double windSpeed;
  final double? humidity; // Ajouté
  final String condition; // Ajouté pour les icônes
  final DateTime? date; // Pour les prévisions

  Weather({
    required this.description,
    required this.temperature,
    required this.windSpeed,
    this.humidity,
    required this.condition,
    this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity']?.toDouble(),
      condition: json['weather'][0]['main'],
      date: json['dt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000) : null,
    );
  }
}