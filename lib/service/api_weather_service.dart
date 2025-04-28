import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String openWeatherKey = '155086bcb12f4e42c364b7f1e4932557';

  Future<List<Map<String, dynamic>>> fetchWeatherDataFor7Days({
    double? lat,
    double? lon,
  }) async {
    double latitude = lat ?? (56.127233 + 57.458273) / 2;
    double longitude = lon ?? (11.124048 + 12.340183) / 2;

    // Obtenir la localisation en fonction de la position
    String location = await _getLocationFromCoordinates(latitude, longitude);
    print('Localisation: $location');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$openWeatherKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur API météo: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    double windSpeed = (data['wind']?['speed'] ?? 0.0) * 3.6; // m/s → km/h
    String weatherDesc = data['weather']?[0]?['main'] ?? 'Unknown';
    double waveHeight = _estimateWaveHeight(windSpeed);
    String windCategory = _mapWindSpeed(windSpeed);
    String waveCategory = _mapWaveHeight(waveHeight);
    String weatherCategory = _mapWeather(weatherDesc);

    final today = DateTime.now();

    return List.generate(7, (i) {
      final day = today.add(Duration(days: i));
      return {
        "Wind Speed": windCategory,
        "Wave Height": waveCategory,
        "Weather": weatherCategory,
        "Day of the Week": _mapDayCategory(day),
        "Full Date": "${_mapDayName(day.weekday)}, ${_formatDate(day)}",
        "Location": location,
        "Temperature": (data['main']?['temp'] ?? 20.0).toString(),
        "Humidity": (data['main']?['humidity'] ?? 60).toString(),
      };
    });
  }

  double _estimateWaveHeight(double windSpeed) {
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
    if (description.contains('clear') || description.contains('sun'))
      return 'Sunny';
    if (description.contains('cloud')) return 'Cloudy';
    return 'Rainy';
  }

  String _mapDayCategory(DateTime date) {
    return (date.weekday >= 6) ? 'Weekend' : 'Weekday';
  }

  String _mapDayName(int weekday) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.day}";
  }

  Future<Map<String, dynamic>> fetchWeatherDataForDay(
    String dayCategory,
  ) async {
    final allData = await fetchWeatherDataFor7Days();
    return allData.firstWhere(
      (entry) => entry['Day of the Week'] == dayCategory,
      orElse:
          () =>
              throw Exception('Aucune donnée météo trouvée pour $dayCategory'),
    );
  }

  Future<String> _getLocationFromCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur API localisation: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);
    String city = data['name']; // Nom de la ville
    String country =
        data['sys']['country']; // Code du pays (ex. "FR" pour la France)

    return '$city, $country';
  }

  String getWeatherAdvice(Map<String, dynamic> weatherData) {
    final windSpeed = weatherData['wind_speed'];
    final condition = weatherData['weather_condition'].toLowerCase();

    if (windSpeed > 20 || condition.contains('storm')) {
      return 'Not recommended - Bad conditions';
    } else if (windSpeed > 10 || condition.contains('rain')) {
      return 'Fair conditions - Be cautious';
    }
    return 'Good conditions - Great time to fish!';
  }
}
