import 'package:fish_app/models/spot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:fish_app/service/api_map_service.dart';

class MapControllerX extends GetxController {
  late MapController mapController;
  var fishingSpots = <GeoPoint, Map<String, dynamic>>{}.obs;
  final MapService mapService = MapService();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeMap();
  }

  void initializeMap() async {
    mapController = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    );

    mapController.listenerMapSingleTapping.addListener(() async {
      GeoPoint? point = mapController.listenerMapSingleTapping.value;
      if (point != null) {
        await addMarkerAtLocation(point);
      }
    });

    await fetchFishingSpots();
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
          latitude: spot.latitude,
          longitude: spot.longitude,
        );

        fishingSpots[point] = {
          'description': spot.description,
          'fish_species': spot.fishSpecies,
          'recommended_techniques':
              spot.recommendedTechniques, // attention à la casse
          'depth': spot.depth, // champ corrigé ici
        };

        await mapController.addMarker(
          point,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
          ),
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
    final spotData = await Get.dialog<Map<String, String>>(
      _buildSpotDetailsDialog(),
    );

    if (spotData == null) return;

    try {
      final spot = Spot(
        name: spotData['name'] ?? 'Nouveau spot',
        latitude: point.latitude,
        longitude: point.longitude,
        description: spotData['description'] ?? '',
        fishSpecies: spotData['fish_species'] ?? '',
        recommendedTechniques: spotData['fish_technique'] ?? '',
        depth: spotData['depth'],
      );

      final success = await mapService.addSpot(spot);

      if (success) {
        fishingSpots[point] = {
          'name': spot.name,
          'description': spot.description,
          'fish_species': spot.fishSpecies,
          'fish_technique': spot.recommendedTechniques,
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

  Widget _buildSpotDetailsDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final fishSpeciesController = TextEditingController();
    final fishTechniqueController = TextEditingController();
    final depthController = TextEditingController();

    return AlertDialog(
      title: Text("Détails du spot de pêche"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nom du spot"),
            ),
            // ... autres champs similaires ...
            TextField(
              controller: fishTechniqueController,
              decoration: InputDecoration(
                labelText: "Technique de pêche",
                hintText: "fish_technique comme dans le backend",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Annuler")),
        ElevatedButton(
          onPressed: () {
            final spotData = {
              'name': nameController.text,
              'description': descriptionController.text,
              'fish_species': fishSpeciesController.text,
              'fish_technique': fishTechniqueController.text,
              'depth': depthController.text,
            };
            Get.back(result: spotData);
          },
          child: Text("Enregistrer"),
        ),
      ],
    );
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
