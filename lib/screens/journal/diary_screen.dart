import 'package:fish_app/widgets/journal/data_selector.dart';
import 'package:fish_app/widgets/journal/journal_app_bar.dart';
import 'package:fish_app/widgets/journal/task_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/screens/journal/add_journal_page.dart';
import 'package:fish_app/widgets/floating_add_button.dart';
import 'package:fish_app/controller/add_journal_controller.dart';

class DiaryScreen extends StatelessWidget {
  final AddJournalController controller = Get.put(AddJournalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String) {}, selectedView: ''),
      body: Column(
        children: [
          // Date selector en haut
          SizedBox(height: 80, child: DateSelector()),

          // Liste des journaux
          Expanded(
            child: Obx(() {
              if (controller.journalEntries.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun journal ajouté pour le moment.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // Récupération des dates triées (du plus récent au plus ancien)
              final sortedDates =
                  controller.journalEntries.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

              return ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  DateTime date = sortedDates[index];
                  List<Map<String, dynamic>> journals =
                      controller.journalEntries[date]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ExpansionTile(
                        title: Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        children:
                            journals.map((journal) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.book,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  '${journal['from']} - ${journal['to']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  journal['description'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddJournalPage()),
          );
        },
      ),
    );
  }
}
