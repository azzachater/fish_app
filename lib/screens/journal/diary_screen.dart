import 'package:fish_app/screens/journal/data_selector.dart';
import 'package:fish_app/screens/journal/fish_journal_card.dart';
import 'package:fish_app/screens/journal/journal_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/screens/journal/add_journal_page.dart';

class JournalScreen extends StatelessWidget {
  final JournalController journalController = Get.put(JournalController());

  JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String view) {}, selectedView: ''),
      body: Column(
        children: [
          const SizedBox(height: 16),
          DateSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final entries = journalController.filteredEntries;
              if (entries.isEmpty) {
                return _buildEmptyState();
              }
              return _buildJournalList(entries);
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => AddJournalPage()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No entries for this date',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a new fishing journal',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList(List<Map<String, dynamic>> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return FishJournalCard(
          entry: entry,
          onDelete: () => journalController.deleteEntry(entry['id']),
          onEdit: () => _navigateToEdit(entry),
        );
      },
    );
  }

  void _navigateToEdit(Map<String, dynamic> entry) async {
    final result = await Get.to(() => AddJournalPage(entry: entry));
    if (result != null) {
      journalController.updateEntry(entry['id'], result);
    }
  }
}
