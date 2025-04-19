import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_weather_service.dart';

class WeatherPredictForm extends StatefulWidget {
  WeatherPredictForm({super.key});
  final WeatherService _weatherService = WeatherService();

  @override
  State<WeatherPredictForm> createState() => _WeatherPredictFormState();
}

class _WeatherPredictFormState extends State<WeatherPredictForm> {
  List<Map<String, dynamic>> daysData = [];
  String selectedDayCategory = 'Weekday';
  String? selectedFullDate;
  String? windSpeed;
  String? waveHeight;
  String? weather;
  String boatCondition = 'Poor';
  String? prediction;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeatherDays();
  }

  Future<void> _loadWeatherDays() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await widget._weatherService.fetchWeatherDataFor7Days();
      final today = DateTime.now();
      final todayCategory = (today.weekday >= 6) ? 'Weekend' : 'Weekday';
      final todayFormatted = "${_weekdayName(today.weekday)}, ${_formatDate(today)}";

      setState(() {
        daysData = data;
        selectedDayCategory = todayCategory;
        selectedFullDate = todayFormatted;
      });

      _loadWeatherDataForSelectedDate(todayFormatted);
    } catch (e) {
      setState(() {
        error = 'Erreur de chargement météo : $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherDataForSelectedDate(String fullDate) async {
    setState(() {
      isLoading = true;
      prediction = null;
    });

    try {
      final weatherData = daysData.firstWhere((day) => day['Full Date'] == fullDate);
      setState(() {
        windSpeed = weatherData["Wind Speed"];
        waveHeight = weatherData["Wave Height"];
        weather = weatherData["Weather"];
        selectedDayCategory = weatherData["Day of the Week"];
        selectedFullDate = fullDate;
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
    if (windSpeed == null || waveHeight == null || weather == null) {
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
      "Day of the Week": selectedDayCategory,
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
      elevation: 5, // Ajout d'une ombre subtile
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Affichage de la localisation
                    Text(
                      'Localisation: ${daysData.isNotEmpty ? daysData[0]['Location'] : 'Chargement...'}',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Liste des jours avec un meilleur design
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daysData.length,
                        itemBuilder: (context, index) {
                          final day = daysData[index];
                          final isSelected = day['Full Date'] == selectedFullDate;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Text(day['Full Date']),
                              selected: isSelected,
                              selectedColor: Colors.blue[600],
                              onSelected: (selected) {
                                if (selected) {
                                  _loadWeatherDataForSelectedDate(day['Full Date']);
                                }
                              },
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Carte de données météo
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      color: Colors.blue[50], // Fond clair
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Données Météo - $selectedFullDate", style: theme.textTheme.titleLarge),
                            const SizedBox(height: 16),
                            weatherTile("🌬️ Vent", "$windSpeed km/h"),
                            weatherTile("🌊 Vagues", "$waveHeight m"),
                            weatherTile("⛅ Temps", weather ?? ""),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown avec icône et meilleur espacement
                    DropdownButtonFormField<String>(
                      value: boatCondition,
                      decoration: InputDecoration(
                        labelText: 'État technique du bateau',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        icon: Icon(Icons.directions_boat), // Icône ajoutée
                      ),
                      items: ['Good', 'Average', 'Poor']
                          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                          .toList(),
                      onChanged: (val) => setState(() => boatCondition = val!),
                    ),
                    const SizedBox(height: 20),

                    // Bouton de prédiction amélioré avec animation
                    Center(
  child: ElevatedButton.icon(
    onPressed: predictWeather,
    icon: const Icon(Icons.waves_rounded),
    label: const Text('Prédire la navigabilité'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),

                    const SizedBox(height: 24),

                    // Affichage de la prédiction avec un fond coloré
                    if (prediction != null)
                      Card(
                        color: Colors.blue[50],
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '🔮 Prédiction: $prediction',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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

  String _weekdayName(int weekday) {
    const names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return names[weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${months[date.month - 1]} ${date.day}";
  }
}
