import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/screens/prediction_ia/location_picker_page.dart';
import 'package:fish_app/service/api_weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_animationController);

    // Chargement séquentiel
    _initLocationAndWeather();
  }

  //nouveau travaille
  Future<void> findFishingSpotsOnly() async {
    setState(() {
      isLoading = true;
      prediction = null; // On n'affiche pas de prédiction météo ici
    });

    try {
      final url = Uri.parse('http://192.168.1.80:5000/spots/recommend');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "lat": currentLocation.latitude,
              "lon": currentLocation.longitude,
              "temp": double.tryParse(temperature ?? '20') ?? 20,
              "wind": double.tryParse(windSpeed ?? '5') ?? 5,
              "humidity": double.tryParse(humidity ?? '60') ?? 60,
              "radius": selectedRadius,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          if (result['spots'] != null && result['spots']['best_spot'] != null) {
            fishingSpots = [
              {
                "latitude": result['spots']['best_spot']['latitude'],
                "longitude": result['spots']['best_spot']['longitude'],
                "distance": result['spots']['best_spot']['distance'],
                "is_best": true,
              },
              ...(result['spots']['other_spots'] as List).map(
                (spot) => ({
                  "latitude": spot['latitude'],
                  "longitude": spot['longitude'],
                  "distance": spot['distance'],
                  "is_best": false,
                }),
              ),
            ];
            showMap = true;
          } else {
            fishingSpots = [];
            showMap = false;
          }
        });
        await _fetchAndDisplayRoute();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        showMap = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initLocationAndWeather() async {
    await _getCurrentLocation(); // Attend la position actuelle
    await _loadWeatherDays(); // Puis charge la météo
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (!serviceEnabled || permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return; // Garde la position par défaut
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        selectedLocationName = "Position actuelle"; // Texte temporaire
      });
    } catch (e) {
      print("Erreur GPS: $e");
      // Conserve la position par défaut
    }
  }

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
      final url = Uri.parse('http://192.168.1.80:5000/recommend');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "lat": currentLocation.latitude,
              "lon": currentLocation.longitude,
              "temp": double.tryParse(temperature ?? '20') ?? 20,
              "wind": double.tryParse(windSpeed ?? '5') ?? 5,
              "humidity": double.tryParse(humidity ?? '60') ?? 60,
              "radius": selectedRadius,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final spotData = jsonDecode(response.body);

        if (spotData.containsKey('error') || spotData['best_spot'] == null) {
          setState(() {
            fishingSpots = [];
            showMap = false;
            // Ajoutez ce message à votre prédiction existante
            if (prediction != null) {
              prediction =
                  '$prediction\n\nAucun spot recommandé trouvé près de votre position actuelle.';
            }
          });
          return;
        }

        setState(() {
          fishingSpots = [
            {
              "latitude": spotData['best_spot']['latitude'],
              "longitude": spotData['best_spot']['longitude'],
              "distance": spotData['best_spot']['distance'],
              "is_best": true,
            },
            ...(spotData['other_spots'] as List).map(
              (spot) => ({
                "latitude": spot['latitude'],
                "longitude": spot['longitude'],
                "distance": spot['distance'],
                "is_best": false,
              }),
            ),
          ];
          showMap = fishingSpots.isNotEmpty;
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        fishingSpots = [];
        showMap = false;
        if (prediction != null) {
          prediction =
              '$prediction\n\nImpossible de charger les spots recommandés.';
        }
      });
    }
  }

  Future<void> checkGoodFishingTime() async {
    setState(() {
      isLoading = true;
      error = null;
      prediction = null;
      showMap = false; // On cache toujours la carte ici
      fishingSpots = []; // On vide les spots
    });

    try {
      final url = Uri.parse('http://192.168.1.80:5000/weather/predict');
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
          prediction =
              result['is_good_weather']
                  ? '✅ Bon moment pour pêcher aujourd\'hui !'
                  : '⛔ Conditions difficiles, soyez prudent.';
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        prediction = 'Erreur: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherDays() async {
    if (currentLocation == null) {
      setState(() {
        error = 'Aucune position disponible';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await widget._weatherService.fetchWeatherDataFor7Days(
        lat: currentLocation.latitude, // Pas de null ici
        lon: currentLocation.longitude,
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
            data.isNotEmpty ? data[0]['Location'] : "Position actuelle";
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
      final url = Uri.parse('http://192.168.1.80:5000/combined/predict');
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
        Uri.parse('http://192.168.1.80:5000/api/session-stats'),
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
    // Styles locaux pour les cartes et listes
    final cardTheme = CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    );

    final listTileTheme = const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    );

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
                    // Section localisation
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
                            ),
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
                        label: const Text('Prédire navigabilité'),
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
                    const SizedBox(height: 16),

                    // Affichage de la prédiction
                    if (prediction != null)
                      Card(
                        color:
                            prediction!.contains('✅')
                                ? Colors.green[50]
                                : Colors.orange[100],
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prediction!.split('\n')[0],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      prediction!.contains('✅')
                                          ? Colors.green
                                          : Colors.orange[800],
                                ),
                              ),
                              if (prediction!.contains('\n')) ...[
                                const SizedBox(height: 8),
                                Text(
                                  prediction!.split('\n').skip(1).join('\n'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    // Section spots (toujours visible)
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 Rayon de recherche (km)',
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
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: findFishingSpotsOnly,
                            icon: const Icon(Icons.location_on),
                            label: const Text('Trouver spots'),
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
                      ],
                    ),

                    // Affichage de la carte si prédiction favorable
                    if (showMap)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  fishingSpots.isNotEmpty &&
                                          fishingSpots[0]['is_best']
                                      ? '⭐ Spot Premium à ${fishingSpots[0]['distance'].toStringAsFixed(1)} km'
                                      : '🎯 Spots recommandés',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 300, // Augmenter la hauteur
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: currentLocation,
                                    zoom: 12.5,
                                    interactiveFlags:
                                        InteractiveFlag.all &
                                        ~InteractiveFlag.rotate,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: const ['a', 'b', 'c'],
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    PolylineLayer(
                                      polylines: [
                                        if (routePoints.isNotEmpty)
                                          Polyline(
                                            points: routePoints,
                                            color: Colors.blue.withOpacity(0.7),
                                            strokeWidth: 4,
                                            borderStrokeWidth: 2,
                                            borderColor: Colors.white,
                                          ),
                                      ],
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        // Votre position actuelle
                                        Marker(
                                          point: currentLocation,
                                          width: 50,
                                          height: 50,
                                          builder:
                                              (ctx) => const Icon(
                                                Icons.sailing,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                        ),
                                        // Spots recommandés
                                        ...fishingSpots
                                            .map(
                                              (spot) => Marker(
                                                point: LatLng(
                                                  spot['latitude'],
                                                  spot['longitude'],
                                                ),
                                                width: 50,
                                                height: 50,
                                                builder:
                                                    (ctx) => Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          spot['is_best']
                                                              ? Icons.flag
                                                              : Icons
                                                                  .location_pin,
                                                          color:
                                                              spot['is_best']
                                                                  ? Colors.green
                                                                  : Colors.blue,
                                                          size: 40,
                                                        ),
                                                        if (spot['distance'] !=
                                                            null)
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                        0.2,
                                                                      ),
                                                                  blurRadius: 2,
                                                                  spreadRadius:
                                                                      1,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Text(
                                                              '${spot['distance'].toStringAsFixed(1)} km',
                                                              style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Légende améliorée
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                child: Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    _buildMapLegend(
                                      Icons.sailing,
                                      'Votre position',
                                      Colors.red,
                                    ),
                                    _buildMapLegend(
                                      Icons.flag,
                                      'Meilleur spot',
                                      Colors.green,
                                    ),
                                    _buildMapLegend(
                                      Icons.location_pin,
                                      'Autres spots',
                                      Colors.blue,
                                    ),
                                    if (routePoints.isNotEmpty)
                                      _buildMapLegend(
                                        Icons.alt_route,
                                        'Itinéraire',
                                        Colors.blue,
                                      ),
                                  ],
                                ),
                              ),
                              // Liste des spots avec détails
                              if (fishingSpots.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Détails des spots:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.3, // 30% de l'écran
                                        ),
                                        child: ListView.separated(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              fishingSpots.take(3).length,
                                          separatorBuilder:
                                              (context, index) =>
                                                  const Divider(height: 8),
                                          itemBuilder: (context, index) {
                                            final spot = fishingSpots[index];
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                leading: Container(
                                                  width: 36,
                                                  height: 36,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        spot['is_best']
                                                            ? Colors.amber
                                                                .withOpacity(
                                                                  0.2,
                                                                )
                                                            : Colors.blue
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    spot['is_best']
                                                        ? Icons.star
                                                        : Icons.location_on,
                                                    color:
                                                        spot['is_best']
                                                            ? Colors.amber
                                                            : Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                                title: Text(
                                                  spot['is_best']
                                                      ? 'Spot premium'
                                                      : 'Spot à ${spot['distance'].toStringAsFixed(1)} km',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '${spot['latitude'].toStringAsFixed(4)}, ${spot['longitude'].toStringAsFixed(4)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  '${spot['distance'].toStringAsFixed(1)} km',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
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
    if (fishingSpots.isNotEmpty && fishingSpots[0]['latitude'] != null) {
      try {
        final spot = LatLng(
          fishingSpots[0]['latitude'] as double,
          fishingSpots[0]['longitude'] as double,
        );
        final points = await fetchRoute(currentLocation, spot);
        setState(() {
          routePoints = points;
        });
      } catch (e) {
        print('Erreur itinéraire: $e');
      }
    }
  }

  Widget _buildMapLegend(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
