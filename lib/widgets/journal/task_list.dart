import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskList extends StatelessWidget {
  final RxList<Map<String, String>> tasks =
      <Map<String, String>>[
        {
          "title": "Brochet",
          "description":
              "Lac - Eau calme, vent léger. Observation : Active le matin.",
          "status": "Enregistré",
          "icon": "🐟",
        },
        {
          "title": "Dorade",
          "description":
              "Mer - Vagues modérées, appât : crevettes. Observation : Bonne prise.",
          "status": "Enregistré",
          "icon": "⚓",
        },
        {
          "title": "Carpe",
          "description":
              "Étang - Eau trouble, appât : maïs. Observation : Difficile à attraper.",
          "status": "Enregistré",
          "icon": "🎣",
        },
      ].obs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              color: Colors.blue[50],
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Text(
                  task["icon"]!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  task["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(task["description"]!),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    task["status"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
