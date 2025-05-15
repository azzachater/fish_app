/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionResultCard extends StatelessWidget {
  final String result;
  final VoidCallback? onViewMap;

  const PredictionResultCard({required this.result, this.onViewMap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: result.contains("✅") ? Colors.green[100] : Colors.red[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onViewMap != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed: onViewMap,
                  child: const Text("Voir les Spots 🗺️"),
                ),
              )
          ],
        ),
      ),
    );
  }
}*/