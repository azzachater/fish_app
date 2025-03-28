import 'package:fish_app/controller/task_controller.dart';
import 'package:fish_app/screens/journal/add_journal_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/journal/data_selector.dart';
import 'package:fish_app/widgets/journal/journal_app_bar.dart';
import 'package:fish_app/widgets/journal/task_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryScreen extends StatelessWidget {
  // Initialiser le contrôleur
  final TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String) {}, selectedView: ''),
      body: Column(
        children: [
          SizedBox(height: 80, child: DateSelector()),
          Obx(() => TaskList(tasks: taskController.tasks)),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () async {
          // Navigation avec GetX
          final result = await Get.to(() => AddJournalPage());
          if (result != null) {
            taskController.addTask(result);
          }
        },
      ),
    );
  }
}
