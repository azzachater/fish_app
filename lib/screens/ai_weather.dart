import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Ajout d’icônes météo
import '../services/api_weather_service.dart';

class WeatherPredictForm extends StatefulWidget {
  WeatherPredictForm({super.key});
  final WeatherService _weatherService = WeatherService();

  @override
  State<WeatherPredictForm> createState() => _WeatherPredictFormState();
}

class _WeatherPredictFormState extends State<WeatherPredictForm> {
  String? windSpeed;
  String? waveHeight;
  String? weather;
  String? dayOfWeek;
  String boatCondition = 'Poor';
  String? prediction;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final weatherData = await widget._weatherService.fetchWeatherData();
      setState(() {
        windSpeed = weatherData["Wind Speed"];
        waveHeight = weatherData["Wave Height"];
        weather = weatherData["Weather"];
        dayOfWeek = weatherData["Day of the Week"];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Erreur lors de la récupération des données météo: $e';
        isLoading = false;
      });
    }
  }

  Future<void> predictWeather() async {
    if (windSpeed == null || waveHeight == null || weather == null || dayOfWeek == null) {
      setState(() {
        prediction = 'Veuillez d’abord charger les données météo.';
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5000/predict');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "Wind Speed": windSpeed,
      "Wave Height": waveHeight,
      "Weather": weather,
      "Day of the Week": dayOfWeek,
      "Boat Technical Condition": boatCondition
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          prediction = result['prediction'];
        });
      } else {
        setState(() {
          prediction = 'Erreur API: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        prediction = 'Erreur de connexion: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Weather Predictor'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : ListView(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text("Données Météo", style: theme.textTheme.titleLarge),
                              const SizedBox(height: 16),
                              weatherTile("🌬️ Vent", "$windSpeed km/h"),
                              weatherTile("🌊 Vagues", "$waveHeight m"),
                              weatherTile("⛅ Temps", weather ?? ""),
                              weatherTile("📅 Jour", dayOfWeek ?? ""),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: boatCondition,
                        decoration: InputDecoration(
                          labelText: 'État technique du bateau',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Good', 'Average', 'Poor']
                            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                            .toList(),
                        onChanged: (val) => setState(() => boatCondition = val!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: predictWeather,
                        icon: const Icon(Icons.waves_rounded),
                        label: const Text('Prédire la navigabilité'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: prediction != null
                            ? Card(
                                key: ValueKey(prediction),
                                color: Colors.blue[50],
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    '🔮 Prédiction: $prediction',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      )
                    ],
                  ),
      ),
    );
  }

  Widget weatherTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.blueGrey, fontSize: 16)),
        ],
      ),
    );
  }
}
