import 'dart:convert';

import 'package:http/http.dart' as http;

class MapService {
  // Pour émulateur Android:
  final String baseUrl = "http://10.0.2.2:8000/api/spots";

  // Pour appareil physique (remplacez par l'IP de votre machine):
  // final String baseUrl = "http://192.168.x.x:8000/api/spots";

  Future<List<dynamic>> getAllSpots() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception("Failed to load spots: ${response.statusCode}");
    } catch (e) {
      print("Erreur réseau: $e");
      rethrow;
    }
  }

  Future<bool> addSpot(
    double latitude,
    double longitude,
    String description,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      }
      print("Erreur serveur: ${response.statusCode} - ${response.body}");
      return false;
    } catch (e) {
      print("Erreur réseau: $e");
      return false;
    }
  }
}
