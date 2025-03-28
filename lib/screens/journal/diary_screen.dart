import 'package:fish_app/screens/journal/add_journal_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/widgets/journal/data_selector.dart';
import 'package:fish_app/widgets/journal/journal_app_bar.dart';
import 'package:fish_app/widgets/journal/task_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryScreen extends StatelessWidget {
  final RxList<Map<String, String>> tasks = <Map<String, String>>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String) {}, selectedView: ''),
      body: Column(
        children: [
          SizedBox(height: 80, child: DateSelector()),
          Obx(() => TaskList()), // Liste des tâches
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddJournalPage()),
          );
          if (result != null) {
            tasks.add(result);
          }
        },
      ),
    );
  }
}
