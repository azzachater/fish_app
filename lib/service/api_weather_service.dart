import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String openWeatherKey = '155086bcb12f4e42c364b7f1e4932557';

  Future<List<Map<String, dynamic>>> fetchWeatherDataFor7Days({
    required double lat, // Maintenant obligatoire
    required double lon, // Maintenant obligatoire
  }) async {
    // Plus de valeurs par défaut !
    final location = await _getLocationFromCoordinates(lat, lon);
    print('Localisation: $location');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$openWeatherKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur API météo: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    // Traitement des données pour 7 jours
    return _processForecastData(data, location);
  }

  List<Map<String, dynamic>> _processForecastData(
    Map<String, dynamic> data,
    String location,
  ) {
    final today = DateTime.now();
    final dailyData = <Map<String, dynamic>>[];

    // Groupement par jour
    final Map<String, List<dynamic>> days = {};
    for (final forecast in data['list']) {
      final date = DateTime.parse(forecast['dt_txt']).toString().split(' ')[0];
      days.putIfAbsent(date, () => []).add(forecast);
    }

    // Pour chaque jour des 7 prochains jours
    for (int i = 0; i < 7; i++) {
      final day = today.add(Duration(days: i));
      final dayStr = day.toString().split(' ')[0];

      if (days.containsKey(dayStr)) {
        final dayForecasts = days[dayStr]!;
        final midDayForecast = dayForecasts.firstWhere(
          (f) => DateTime.parse(f['dt_txt']).hour >= 12,
          orElse: () => dayForecasts[dayForecasts.length ~/ 2],
        );

        double windSpeed = (midDayForecast['wind']['speed'] ?? 0.0) * 3.6;
        String weatherDesc = midDayForecast['weather'][0]['main'] ?? 'Unknown';

        dailyData.add({
          "Wind Speed": _mapWindSpeed(windSpeed),
          "Wave Height": _mapWaveHeight(_estimateWaveHeight(windSpeed)),
          "Weather": _mapWeather(weatherDesc),
          "Day of the Week": _mapDayCategory(day),
          "Full Date": "${_mapDayName(day.weekday)}, ${_formatDate(day)}",
          "Location": location,
          "Temperature": (midDayForecast['main']['temp'] ?? 20.0).toString(),
          "Humidity": (midDayForecast['main']['humidity'] ?? 60).toString(),
        });
      }
    }

    return dailyData;
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
