// fishing_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FishingMap extends StatelessWidget {
  final LatLng currentPosition;
  final List<LatLng> fishingSpots;
  
  const FishingMap({
    super.key,
    required this.currentPosition,
    required this.fishingSpots,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: currentPosition,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentPosition,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              ...fishingSpots.map(
                (spot) => Marker(
                  point: spot,
                  builder: (ctx) => const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}