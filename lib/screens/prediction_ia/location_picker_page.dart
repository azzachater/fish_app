import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? selectedLocation;
  LatLng defaultCenter = const LatLng(56.7927, 11.1240); // Position par défaut
  bool isLoading = true; // 👈 Loader pendant la recherche GPS

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (!serviceEnabled || permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          defaultCenter = LatLng(position.latitude, position.longitude);
          selectedLocation = defaultCenter;
        });
      }
    } catch (e) {
      // Ignore erreur, on garde position par défaut
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectLocation(LatLng latlng) {
    setState(() {
      selectedLocation = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗺️ Choisir un lieu'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 🔥 Le Loader
          : FlutterMap(
              options: MapOptions(
                center: defaultCenter,
                zoom: 10.0,
                onTap: (tapPosition, point) {
                  _selectLocation(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: selectedLocation!,
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: selectedLocation != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, selectedLocation);
              },
              icon: const Icon(Icons.check),
              label: const Text("Confirmer"),
            )
          : null,
    );
  }
}
