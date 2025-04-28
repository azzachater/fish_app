import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/screens/prediction_ia/LiveFishingScreen.dart';
import 'package:fish_app/screens/prediction_ia/location_picker_page.dart';
import 'package:fish_app/service/api_weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPredictForm extends StatefulWidget {
  WeatherPredictForm({super.key});
  final WeatherService _weatherService = WeatherService();

  @override
  State<WeatherPredictForm> createState() => _WeatherPredictFormState();
}

class _WeatherPredictFormState extends State<WeatherPredictForm>
    with SingleTickerProviderStateMixin {
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
  List<dynamic> fishingSpots = [];
  bool showMap = false;
  LatLng currentLocation = const LatLng(56.7927, 11.1240);
  String? temperature;
  String? humidity;
  double selectedRadius = 100; // pour le choix du rayon max (en km)
  String selectedLocationName = "Chargement..."; // nouvelle variable
  List<LatLng> routePoints = []; //pour stocker le trajet
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _loadWeatherDays();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_animationController);
  }

  //nouveau travaille

  void _chooseLocationManually() async {
    final LatLng? selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (selected != null) {
      setState(() {
        currentLocation = selected;
        // On réinitialise la localisation affichée pour forcer à recharger après météo
        selectedLocationName = 'Chargement...';
      });

      await _loadWeatherDays(); // Charge uniquement la météo de la nouvelle position
      // ❌ PAS de fetchRecommendedSpots ici !
    }
  }

  Future<void> fetchRecommendedSpots() async {
    try {
      final url = Uri.parse('http://192.168.1.52:5000/recommend');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "lat": currentLocation.latitude,
              "lon": currentLocation.longitude,
              "temp":
                  double.tryParse(temperature ?? '20') ?? 20, // 🧠 temp réelle
              "wind": double.tryParse(windSpeed ?? '5') ?? 5,
              "humidity": double.tryParse(humidity ?? '60') ?? 60,
              "radius": selectedRadius, // Rayon sélectionné par slider
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final spotData = jsonDecode(response.body);
        print('Recommended Spot: $spotData');

        setState(() {
          fishingSpots = [
            {
              "latitude": spotData['spot']['lat'],
              "longitude": spotData['spot']['lon'],
              "distance": spotData['distance_km'],
            },
          ];
          showMap = true;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          fishingSpots = [];
          showMap = false;
          prediction = "Aucun spot trouvé proche de votre position 😔";
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        fishingSpots = [];
        showMap = false;
        error = 'Erreur recommandation: ${e.toString()}';
      });
    }
  }

  Future<void> checkGoodFishingTime() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final url = Uri.parse('http://192.168.1.52:5000/weather/predict');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "Wind Speed": windSpeed,
              "Wave Height": waveHeight,
              "Weather": weather,
              "Day of the Week": selectedDayCategory,
              "Boat Technical Condition": boatCondition,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print(result);

        final bool goodTime = (result['is_good_weather'] ?? false) == true;

        setState(() {
          prediction =
              goodTime
                  ? '✅ Bon moment pour pêcher aujourd\'hui !'
                  : '⚠️ Conditions difficiles, soyez prudent.';
        });

        // ➡️ Peu importe "goodTime" => on essaye quand même de chercher des spots !
        await fetchRecommendedSpots();
        await _fetchAndDisplayRoute();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        prediction = 'Erreur: ${e.toString()}';
        showMap = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherDays() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await widget._weatherService.fetchWeatherDataFor7Days(
        lat: currentLocation?.latitude,
        lon: currentLocation?.longitude,
      );

      final today = DateTime.now();
      final todayCategory = (today.weekday >= 6) ? 'Weekend' : 'Weekday';
      final todayFormatted =
          "${_weekdayName(today.weekday)}, ${_formatDate(today)}";

      setState(() {
        daysData = data;
        selectedDayCategory = todayCategory;
        selectedFullDate = todayFormatted;
        selectedLocationName =
            data.isNotEmpty ? data[0]['Location'] : 'Inconnue';
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
      fishingSpots = [];
      showMap = false;
    });

    try {
      final weatherData = daysData.firstWhere(
        (day) => day['Full Date'] == fullDate,
      );
      setState(() {
        windSpeed = weatherData["Wind Speed"];
        waveHeight = weatherData["Wave Height"];
        weather = weatherData["Weather"];
        selectedDayCategory = weatherData["Day of the Week"];
        selectedFullDate = fullDate;
        isLoading = false;
        // ✅ Ajouter température et humidité récupérées
        temperature = weatherData["Temperature"];
        humidity = weatherData["Humidity"];
      });
    } catch (e) {
      setState(() {
        error = 'Erreur lors de la récupération des données météo: $e';
        isLoading = false;
      });
    }
  }

  Future<void> predictWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final url = Uri.parse('http://192.168.1.52:5000/combined/predict');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "Wind Speed": windSpeed,
              "Wave Height": waveHeight,
              "Weather": weather,
              "Day of the Week": selectedDayCategory,
              "Boat Technical Condition": boatCondition,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          prediction = result['weather']['prediction'];
          if (result['weather']['is_good'] &&
              result.containsKey('fishing_spots')) {
            fishingSpots = result['fishing_spots'];
            showMap = true;
          } else {
            fishingSpots = [];
            showMap = false;
          }
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        prediction = 'Erreur: ${e.toString()}';
        showMap = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Méthode pour afficher les stats
  void _showFishingStats() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.52:5000/api/session-stats'),
      );

      if (response.statusCode == 200) {
        final stats = jsonDecode(response.body);

        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Statistiques de pêche'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Durée moyenne: ${stats['mean_duration']} minutes'),
                    Text('Distance moyenne: ${stats['mean_distance']} km'),
                    const SizedBox(height: 16),
                    const Text('Exemple de sessions:'),
                    ...stats['sample_sessions']
                        .map(
                          (s) => ListTile(
                            title: Text('Session #${s['session_id']}'),
                            subtitle: Text(
                              '${s['session_duration']} min, ${s['session_distance']} km',
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
        );
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des stats: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> routePoints = [];

    if (fishingSpots.isNotEmpty) {
      final firstSpot = fishingSpots.first;
      routePoints = [
        currentLocation,
        LatLng(firstSpot['latitude'], firstSpot['longitude']),
      ];
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Weather Predictor'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.lightPrimary,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Localisation: $selectedLocationName',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _chooseLocationManually,
                      icon: const Icon(Icons.map),
                      label: const Text('Choisir un lieu'),
                    ),

                    // Liste des jours
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daysData.length,
                        itemBuilder: (context, index) {
                          final day = daysData[index];
                          final isSelected =
                              day['Full Date'] == selectedFullDate;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Text(day['Full Date']),
                              selected: isSelected,
                              selectedColor: AppTheme.primaryColor,
                              onSelected: (selected) {
                                if (selected) {
                                  _loadWeatherDataForSelectedDate(
                                    day['Full Date'],
                                  );
                                }
                              },
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? AppTheme.lightPrimary
                                        : Colors.black,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Données Météo - $selectedFullDate",
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildWeatherTile("🌬️ Vent", "$windSpeed km/h"),
                            _buildWeatherTile("🌊 Vagues", "$waveHeight m"),
                            _buildWeatherTile("⛅ Temps", weather ?? ""),
                            _buildWeatherTile(
                              "🌡️ Température",
                              "${temperature ?? '...'} °C",
                            ), // ✅ ajouté
                            _buildWeatherTile(
                              "💧 Humidité",
                              "${humidity ?? '...'} %",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // État du bateau
                    DropdownButtonFormField<String>(
                      value: boatCondition,
                      decoration: InputDecoration(
                        labelText: 'État technique du bateau',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        icon: const Icon(Icons.directions_boat),
                      ),
                      items:
                          ['Good', 'Average', 'Poor']
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt,
                                  child: Text(opt),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => boatCondition = val!),
                    ),
                    const SizedBox(height: 20),

                    // Bouton de prédiction
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: checkGoodFishingTime,

                        icon: const Icon(Icons.waves_rounded),
                        label: const Text('Prédire la navigabilité'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.lightPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LiveFishingScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.sailing_rounded),
                        label: const Text('🎣 Mode Pêche Live'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 Choisissez le rayon de recherche (km)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: selectedRadius,
                          min: 10,
                          max: 200,
                          divisions: 19,
                          label: '${selectedRadius.round()} km',
                          onChanged: (value) {
                            setState(() {
                              selectedRadius = value;
                            });
                          },
                        ),
                      ],
                    ),

                    // Affichage de la prédiction
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Affichage de la carte si prédiction favorable
                    if (showMap)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '🎯 Spots recommandés autour de vous',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 250,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: currentLocation,
                                    zoom: 12.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        // 🛑 Marqueur pour TA LOCALISATION
                                        Marker(
                                          width: 80.0,
                                          height: 80.0,
                                          point: currentLocation,
                                          builder:
                                              (ctx) => const Icon(
                                                Icons
                                                    .my_location, // 🧠 Icône différente
                                                color:
                                                    Colors
                                                        .red, // 🛑 Couleur rouge pour toi
                                                size: 40,
                                              ),
                                        ),

                                        // 🎯 Marqueurs pour les SPOTS RECOMMANDÉS
                                        ...fishingSpots.map((spot) {
                                          return Marker(
                                            width: 80.0,
                                            height: 80.0,
                                            point: LatLng(
                                              spot['latitude'],
                                              spot['longitude'],
                                            ),
                                            builder:
                                                (ctx) => const Icon(
                                                  Icons
                                                      .location_on, // 🎣 Icône classique
                                                  color:
                                                      Colors
                                                          .blue, // 🔵 Couleur bleu pour spot
                                                  size: 40,
                                                ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                    if (routePoints.isNotEmpty)
                                      AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, child) {
                                          return PolylineLayer(
                                            polylines: [
                                              Polyline(
                                                points: routePoints,
                                                strokeWidth: 5.0,
                                                color: Colors.blueAccent
                                                    .withOpacity(
                                                      _opacityAnimation.value,
                                                    ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.my_location,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Vous êtes ici',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Spot recommandé',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }

  Widget _buildWeatherTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _weekdayName(int weekday) {
    const names = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return names[weekday - 1];
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

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    const apiKey =
        '5b3ce3597851110001cf6248f0080afa69864f5d99d3eb1bbfcb9ced'; // Mets ta clé ici !
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['features'][0]['geometry']['coordinates'];

      return geometry.map<LatLng>((point) {
        return LatLng(point[1], point[0]);
      }).toList();
    } else {
      throw Exception('Erreur itinéraire: ${response.statusCode}');
    }
  }

  //pour chargr la route
  Future<void> _fetchAndDisplayRoute() async {
    if (currentLocation != null && fishingSpots.isNotEmpty) {
      final spot = LatLng(
        fishingSpots[0]['latitude'],
        fishingSpots[0]['longitude'],
      );

      try {
        final points = await fetchRoute(currentLocation!, spot);
        setState(() {
          routePoints = points;
        });
      } catch (e) {
        print('Erreur chargement route: $e');
      }
    }
  }
}
