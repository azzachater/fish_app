import 'dart:async';
import 'dart:convert';
import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LiveFishingScreen extends StatefulWidget {
  const LiveFishingScreen({Key? key}) : super(key: key);

  @override
  State<LiveFishingScreen> createState() => _LiveFishingScreenState();
}

class _LiveFishingScreenState extends State<LiveFishingScreen> {
  final String userId = "user_123";
  bool isFishing = false;
  bool isLoading = false;
  Timer? timer;
  LatLng? currentLocation;
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? recommendation;
  String? errorMessage;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _startFishingSession() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation = LatLng(position.latitude, position.longitude);

      final response = await http.post(
        Uri.parse('http://192.168.1.52:5000/live/start'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'lat': position.latitude,
          'lon': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFishing = true;
        });
        _startLiveUpdates();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _stopFishingSession() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.52:5000/live/stop/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFishing = false;
          recommendation = null;
          weatherData = null;
        });
        timer?.cancel();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: $e';
      });
    }
  }

  void _startLiveUpdates() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(minutes: 5), (Timer t) {
      _fetchLiveStatus();
    });
    _fetchLiveStatus();
  }

  Future<void> _fetchLiveStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.52:5000/live/status/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          currentLocation = LatLng(
            data['location']['lat'],
            data['location']['lon'],
          );
          weatherData = data['weather'];
          recommendation = data['recommendation'];
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎣 Live Fishing Mode'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isFishing)
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _startFishingSession,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Démarrer session Live'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                          ),
                        ),
                      if (isFishing) ...[
                        if (weatherData != null) _buildWeatherCard(),
                        const SizedBox(height: 16),
                        if (recommendation != null) _buildRecommendationCard(),
                        const SizedBox(height: 16),
                        _buildLiveMap(),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _fetchLiveStatus,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Actualiser'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _stopFishingSession,
                            icon: const Icon(Icons.stop),
                            label: const Text('Arrêter session Live'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.lightBlue[50],
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Conditions Actuelles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherTile(Icons.thermostat, '${weatherData?['temp'] ?? '--'} °C'),
                _buildWeatherTile(Icons.wind_power, '${weatherData?['wind'] ?? '--'} km/h'),
                _buildWeatherTile(Icons.water_drop, '${weatherData?['humidity'] ?? '--'} %'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherTile(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildRecommendationCard() {
    final isFavorable = recommendation?['weather_status'] == "favorable";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isFavorable ? Colors.blue[100] : Colors.red[100],
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            isFavorable ? '✅ Bon endroit pour pêcher !' : '🚫 Pas recommandé ici.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isFavorable ? Colors.blue[800] : Colors.red[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveMap() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: SizedBox(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            center: currentLocation,
            zoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                if (currentLocation != null)
                  Marker(
                    point: currentLocation!,
                    builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                if (recommendation != null && recommendation?['spot'] != null)
                  Marker(
                    point: LatLng(
                      recommendation!['spot']['lat'],
                      recommendation!['spot']['lon'],
                    ),
                    builder: (ctx) => const Icon(Icons.flag, color: Colors.blue, size: 40),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
