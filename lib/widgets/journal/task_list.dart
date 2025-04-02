import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TaskList extends StatelessWidget {
  final RxList<Map<String, String>> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Map<String, String> task) {
    return Card(
      child: ListTile(
        leading: Text(task["icon"] ?? "📝", style: TextStyle(fontSize: 24)),
        title: Text(task["title"] ?? "Sans titre"),
        subtitle: Text(task["description"] ?? ""),
        trailing: Chip(
          label: Text(task["status"] ?? "Nouveau"),
          backgroundColor: Colors.blue[100],
        ),
      ),
    );
  }
}
