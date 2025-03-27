import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapControllerX extends GetxController {
  late MapController mapController;
  var fishingSpots =
      <GeoPoint, String>{}.obs; // Stocke les spots et leurs descriptions

  @override
  void onInit() {
    super.onInit();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );

    // Écouter les clics sur la carte
    mapController.listenerMapSingleTapping.addListener(() async {
      GeoPoint? point = mapController.listenerMapSingleTapping.value;
      if (point != null) {
        addMarkerAtLocation(point);
      }
    });
  }

  void moveToCurrentLocation() async {
    await mapController.currentLocation();
  }

  void addMarkerAtLocation(GeoPoint point) async {
    String? description = await Get.dialog<String>(_buildCommentDialog());

    if (description != null && description.isNotEmpty) {
      fishingSpots[point] = description;

      await mapController.addMarker(
        point,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 56),
        ),
      );
    }
  }

  void showMarkerInfo(GeoPoint point) {
    String description = fishingSpots[point] ?? "Pas de description";
    Get.defaultDialog(
      title: "Infos du Spot",
      middleText: description,
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: Text("Fermer"),
      ),
    );
  }

  Widget _buildCommentDialog() {
    TextEditingController controller = TextEditingController();
    return AlertDialog(
      title: Text("Ajouter un commentaire"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "Décrivez ce spot..."),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null),
          child: Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: controller.text),
          child: Text("Valider"),
        ),
      ],
    );
  }

  @override
  void onClose() {
    mapController.dispose(); // Libérer la mémoire
    super.onClose();
  }
}
