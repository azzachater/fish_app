import 'package:fish_app/screens/add_journal_page.dart';
import 'package:fish_app/widgets/data_selector.dart';
import 'package:fish_app/widgets/journal_app_bar.dart';
import 'package:fish_app/widgets/task_list.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(),
      body: Column(
        children: [
          SizedBox(height: 80, child: DateSelector()),
          TaskList(), // Liste des tâches
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ouvrir la formulaire
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddJournalPage()),
          );
        },
      ),
    );
  }
}
