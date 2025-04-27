/*import 'package:fish_app/models/spot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class SpotMarker extends Marker {
  final Spot spot;
  final VoidCallback? onTap;

  SpotMarker({required this.spot, this.onTap})
      : super(
          width: 40,
          height: 40,
          point: spot.position,
          builder: (ctx) => GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        );
}
*/