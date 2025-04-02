import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:fish_app/service/map_service.dart';

class MapControllerX extends GetxController {
  late MapController mapController;
  var fishingSpots = <GeoPoint, String>{}.obs;
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
          latitude: spot['latitude'],
          longitude: spot['longitude'],
        );
        fishingSpots[point] = spot['description'];
        await mapController.addMarker(
          point,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.location_pin, color: Colors.blue, size: 48),
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
    final description = await Get.dialog<String>(_buildCommentDialog());
    if (description == null || description.isEmpty) return;

    try {
      final success = await mapService.addSpot(
        point.latitude,
        point.longitude,
        description,
      );

      if (success) {
        await fetchFishingSpots(); // Rafraîchir les spots
        Get.snackbar("Succès", "Spot ajouté avec succès!");
      } else {
        Get.snackbar("Erreur", "Échec de l'ajout du spot");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Exception: ${e.toString()}");
    }
  }

  Widget _buildCommentDialog() {
    final controller = TextEditingController();
    return AlertDialog(
      title: Text("Description du spot"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Poissons présents, profondeur...",
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Annuler")),
        ElevatedButton(
          onPressed: () => Get.back(result: controller.text),
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
