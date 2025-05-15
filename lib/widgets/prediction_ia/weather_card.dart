/*import 'package:fish_app/models/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({required this.weather, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Weather",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text("🌤️ ${weather.description}", style: TextStyle(fontSize: 16)),
            Text("🌡️ ${weather.temperature}°C", style: TextStyle(fontSize: 16)),
            Text("🌬️ ${weather.windSpeed} km/h", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
*/