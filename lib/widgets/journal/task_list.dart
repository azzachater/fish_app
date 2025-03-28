import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/data_selector_controller.dart';

class TaskList extends StatelessWidget {
  final DateSelectorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final tasks = controller.getJournalForSelectedDate();
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
        );
      }),
    );
  }
}
