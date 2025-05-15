import 'dart:async';

import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/models/spot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:fish_app/service/api_map_service.dart';
import 'package:latlong2/latlong.dart';

class MapControllerX extends GetxController {
  late MapController mapController;
  var fishingSpots = <GeoPoint, Map<String, dynamic>>{}.obs;
  final MapService mapService = MapService();
  final isLoading = false.obs;
  bool _isMapInitialized = false;
  var selectedSpecies = ''.obs;
  var selectedDepth = ''.obs;
  var speciesList = ['Truite', 'Perche', 'Brochet'].obs; // Exemple d'espèces

  @override
  void onInit() {
    super.onInit();
    initializeMap();

    Timer.periodic(Duration(seconds: 30), (_) => fetchFishingSpots());
  }

  Future<void> initializeMap() async {
    try {
      mapController = MapController(
        initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      );

      mapController.listenerMapSingleTapping.addListener(() async {
        GeoPoint? point = mapController.listenerMapSingleTapping.value;
        if (point != null) {
          await addMarkerAtLocation(point);
        }
      });

      _isMapInitialized = true;
      await fetchFishingSpots();
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Échec d'initialisation de la carte: ${e.toString()}",
      );
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await mapController.myLocation();
      await mapController.goToLocation(position);
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible d'obtenir la position: ${e.toString()}",
      );
    }
  }

  Future<void> fetchFishingSpots() async {
    try {
      isLoading(true);
      final spots = await mapService.getAllSpots();
      fishingSpots.clear();

      for (var spot in spots) {
        final point = GeoPoint(
          latitude: spot.position.latitude,
          longitude: spot.position.longitude,
        );

        fishingSpots[point] = {
          'name': spot.name,
          'description': spot.description,
          'fish_species': spot.fishSpecies,
          'recommended_techniques': spot.recommendedTechniques,
          'depth': spot.depth,
        };

        await mapController.addMarker(
          point,
          markerIcon: _getFishMarkerIcon(spot.fishSpecies), // Utilisation ici
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de charger les spots: ${e.toString()}",
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addMarkerAtLocation(GeoPoint point) async {
    final spotData = await Get.bottomSheet<Map<String, String>>(
      _buildSpotDetailsBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );

    if (spotData == null) return;

    try {
      final depthValue = double.tryParse(spotData['depth'] ?? '');

      final spot = Spot(
        name: spotData['name'] ?? 'Nouveau spot',
        position: LatLng(point.latitude, point.longitude),
        description: spotData['description'] ?? '',
        fishSpecies: spotData['fish_species'] ?? '',
        recommendedTechniques: spotData['recommendedTechniques'] ?? '',
        depth: depthValue,
      );

      final success = await mapService.addSpot(spot);

      if (success) {
        fishingSpots[point] = {
          'name': spot.name,
          'description': spot.description,
          'fish_species': spot.fishSpecies,
          'recommendedTechniques': spot.recommendedTechniques,
          'depth': spot.depth,
        };

        await mapController.addMarker(
          point,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
          ),
        );

        Get.snackbar("Succès", "Spot ajouté avec succès!");
      }
    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    }
  }

  Widget _buildSpotDetailsBottomSheet() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final fishSpeciesController = TextEditingController();
    final techniqueController = TextEditingController();
    final depthController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ajouter un nouveau spot",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nom du spot"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: fishSpeciesController,
              decoration: InputDecoration(labelText: "Espèces de poissons"),
            ),
            TextField(
              controller: techniqueController,
              decoration: InputDecoration(labelText: "Techniques recommandées"),
            ),
            TextField(
              controller: depthController,
              decoration: InputDecoration(labelText: "Profondeur (m)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Annuler"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.snackbar(
                          "Erreur",
                          "Le nom du spot est obligatoire",
                        );
                        return;
                      }

                      Get.back(
                        result: {
                          'name': nameController.text,
                          'description': descriptionController.text,
                          'fish_species': fishSpeciesController.text,
                          'recommendedTechniques': techniqueController.text,
                          'depth': depthController.text,
                        },
                      );
                    },
                    child: Text("Ajouter le spot"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    if (_isMapInitialized) {
      try {
        mapController.dispose();
      } catch (e) {
        print("Erreur lors de la fermeture du MapController: $e");
      }
    }
    super.onClose();
  }
  ///// pour le filter
  /*void applyFilters() {
    // Appliquer les filtres sur la liste des spots
    var filteredSpots = fishingSpots.values.where((spot) {
      bool matchesSpecies = selectedSpecies.value.isEmpty || spot['fish_species'] == selectedSpecies.value;
      bool matchesDepth = selectedDepth.value.isEmpty || spot['depth'] == selectedDepth.value;
      return matchesSpecies && matchesDepth;
    }).toList();

    // Mettre à jour les spots filtrés sur la carte
    updateMapMarkers(filteredSpots);
  }*/

  void updateMapMarkers(List<Map<String, dynamic>> filteredSpots) {
    // Logique pour mettre à jour les marqueurs de la carte avec les spots filtrés
  }
  MarkerIcon _getFishMarkerIcon(String fishSpecies) {
    String assetPath;

    // Convertir en minuscules pour la comparaison
    final species = fishSpecies.toLowerCase();

    if (species.contains('truite')) {
      assetPath = 'assets/images/markers/trout_fish.png';
    } else if (species.contains('perche')) {
      assetPath = 'assets/images/markers/perch_fish.png';
    } else if (species.contains('brochet')) {
      assetPath = 'assets/images/markers/pike_fish.png';
    } else {
      assetPath = 'assets/images/markers/default_fish.png';
    }

    return MarkerIcon(
      iconWidget: Image.asset(
        assetPath,
        width: 48,
        height: 48,
        errorBuilder:
            (context, error, stackTrace) =>
                Icon(Icons.location_pin, color: Colors.red, size: 48),
      ),
    );
  }

  Future<bool> voteOnSpot({
    required int spotId,
    required int userId,
    required bool isUpvote,
  }) async {
    try {
      final success = await mapService.voteOnSpot(
        spotId: spotId,
        userId: userId,
        isUpvote: isUpvote,
      );

      if (success) {
        // Rafraîchir les spots après le vote
        await fetchFishingSpots();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Erreur", "Échec lors du vote: ${e.toString()}");
      return false;
    }
  }
}
