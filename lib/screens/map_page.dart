import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController controller = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  @override
  void dispose() {
    controller.dispose(); // Libérer la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carte de Pêche")),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
              userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(Icons.double_arrow, size: 48),
                ),
              ),
              roadConfiguration: RoadOption(roadColor: Colors.yellowAccent),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                await controller.currentLocation();
              },
              child: Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                await controller.addMarker(
                  GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
                  markerIcon: MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add_location),
            ),
          ),
        ],
      ),
    );
  }
}
