/*import 'package:fish_app/controller/fishing_prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FishingPredictionController>();
    return Obx(() => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  controller.currentWeather['location'] ?? 'Chargement...',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${controller.currentWeather['temperature'] ?? '--'}°C',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Text('Température'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          controller.currentWeather['condition'] ?? '--',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          controller.currentWeather['icon'] ?? '☀️',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${controller.currentWeather['wind'] ?? '--'} km/h',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Text('Vent'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
*/