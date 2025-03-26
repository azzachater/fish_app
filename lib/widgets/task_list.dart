import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Map<String, String>> tasks = [
    {
      "title": "Pêche au brochet",
      "description": "Spot de pêche au lac",
      "status": "Planned",
      "icon": "🐟",
    },
    {
      "title": "Sortie en mer",
      "description": "Prévoir les appâts et le matériel",
      "status": "Completed",
      "icon": "⚓",
    },
    {
      "title": "Compétition de pêche",
      "description": "Préparation pour le tournoi",
      "status": "Upcoming",
      "icon": "🎣",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            color: Colors.blue[50], // Couleur douce rappelant l'eau
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Text(
                task["icon"]!,
                style: TextStyle(fontSize: 24),
              ), // Icône personnalisée
              title: Text(
                task["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(task["description"]!),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      task["status"] == "Planned"
                          ? Colors.blue
                          : task["status"] == "Completed"
                          ? Colors.green
                          : Colors.orange,
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
    );
  }
}
