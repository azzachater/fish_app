import 'package:fish_app/controller/task_controller.dart';
import 'package:fish_app/screens/journal/add_journal_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/journal/data_selector.dart';
import 'package:fish_app/widgets/journal/journal_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DiaryScreen extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String view) {}, selectedView: ''),
      body: Obx(
        () => Column(
          children: [
            SizedBox(height: 80, child: DateSelector()),
            Expanded(
              child: ListView.builder(
                itemCount: taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.tasks[index];
                  return Dismissible(
                    key: Key(task["title"] + index.toString()),
                    onDismissed: (direction) {
                      taskController.removeTask(index);
                      Get.snackbar(
                        'Succès',
                        'Journal supprimé',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    background: Container(color: Colors.red),
                    child: _buildTaskCard(task),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () async {
          final result = await Get.to(() => AddJournalPage());
          if (result != null) {
            taskController.addTask(Map<String, dynamic>.from(result));
          }
        },
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      child: ListTile(
        leading: Text(task["icon"] ?? "📝", style: TextStyle(fontSize: 24)),
        title: Text(task["title"] ?? "Sans titre"),
        subtitle: Text(task["description"] ?? ""),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            final index = taskController.tasks.indexOf(task);
            if (index != -1) {
              taskController.removeTask(index);
              Get.snackbar(
                'Succès',
                'Journal supprimé',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
        ),
      ),
    );
  }
}
