import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapControllerX extends GetxController {
  late MapController mapController;

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
  }

  void moveToCurrentLocation() async {
    await mapController.currentLocation();
  }

  void addMarkerAtLocation() async {
    await mapController.addMarker(
      GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      markerIcon: MarkerIcon(
        icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56),
      ),
    );
  }

  @override
  void onClose() {
    mapController.dispose(); // Libérer la mémoire
    super.onClose();
  }
}
