import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String openWeatherKey = '155086bcb12f4e42c364b7f1e4932557';

  Future<Map<String, dynamic>> fetchWeatherData() async {
    double lat = 48.8566; // Paris
    double lon = 2.3522;

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherKey');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur API météo: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    // Extraction
    double windSpeed = (data['wind']?['speed'] ?? 0.0) * 3.6; // m/s → km/h
    String weatherDesc = data['weather']?[0]?['main'] ?? 'Unknown';

    // Simulation de la hauteur des vagues selon le vent
    double waveHeight = _estimateWaveHeight(windSpeed);

    // Mapping
    String windCategory = _mapWindSpeed(windSpeed);
    String waveCategory = _mapWaveHeight(waveHeight);
    String weatherCategory = _mapWeather(weatherDesc);
    String dayOfWeek = _getDayCategory();

    return {
      "Wind Speed": windCategory,
      "Wave Height": waveCategory,
      "Weather": weatherCategory,
      "Day of the Week": dayOfWeek,
    };
  }

  double _estimateWaveHeight(double windSpeed) {
    // Estimation simple : vague ~ proportionnelle au vent
    if (windSpeed < 10) return 0.3;
    if (windSpeed < 20) return 1.0;
    return 2.0;
  }

  String _mapWindSpeed(double speed) {
    if (speed < 10) return 'Low';
    if (speed < 20) return 'Medium';
    return 'High';
  }

  String _mapWaveHeight(double height) {
    if (height < 0.5) return 'Low';
    if (height < 1.5) return 'Medium';
    return 'High';
  }

  String _mapWeather(String description) {
    description = description.toLowerCase();
    if (description.contains('clear') || description.contains('sun')) return 'Sunny';
    if (description.contains('cloud')) return 'Cloudy';
    return 'Rainy';
  }

  String _getDayCategory() {
    final now = DateTime.now();
    return (now.weekday == 6 || now.weekday == 7) ? 'Weekend' : 'Weekday';
  }
}
