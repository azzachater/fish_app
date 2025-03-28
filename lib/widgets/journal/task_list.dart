import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TaskList extends StatelessWidget {
  final RxList<Map<String, String>> tasks;

  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              task["icon"] ?? "📝",
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              task["title"] ?? "Sans titre",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(task["description"] ?? "Aucune description"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                task["status"] ?? "Enregistré",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
