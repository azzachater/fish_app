/*import 'package:fish_app/controller/fishing_prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FishingPredictionController>();

    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PRÉVISIONS 7 JOURS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.forecast.length,
                itemBuilder: (ctx, index) {
                  final day = controller.forecast[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(day['day']),
                        Text('${day['temp']}°C'),
                        Text(day['icon']),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}*/