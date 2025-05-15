import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/models/fishingJournal.dart';
import 'package:fish_app/screens/journal/add_journal_page.dart';
import 'package:fish_app/screens/journal/data_selector.dart';
import 'package:fish_app/screens/journal/fish_journal_card.dart';
import 'package:fish_app/screens/journal/journal_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalScreen extends StatelessWidget {
  final JournalController controller = Get.find<JournalController>();

  JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterByDate(DateTime.now());
    });
    return Scaffold(
      appBar: JournalAppBar(onViewChange: (String view) {}, selectedView: ''),
      body: Column(
        children: [
          DateSelector(),
          Expanded(
            child: Obx(() {
              if (controller.filteredEntries.isEmpty) {
                return _buildEmptyState();
              }
              return _buildJournalList(controller.filteredEntries);
            }),
          ),
        ],
      ),
      // Modifiez le FloatingActionButton :
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.add,
          size: 60,
          color: AppTheme.lightPrimary,
        ),
        onPressed: () async {
          final result = await Get.to(() => AddJournalPage());
          if (result != null) {
            controller.filterByDate(DateTime.now()); // Rafraîchit l'affichage
          }
        },
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
            'Aucune entrée pour cette date',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune entrée pour cette date',
            style: TextStyle(fontSize: 18, color: AppTheme.darkPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList(List<FishingJournal> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return FishJournalCard(
          entry: entry,
          onDelete: () => controller.deleteEntry(entry.id),
          onEdit: () => _navigateToEdit(entry),
        );
      },
    );
  }

  void _navigateToEdit(FishingJournal entry) async {
    final result = await Get.to<FishingJournal?>(
      () => AddJournalPage(entry: entry),
    );

    if (result != null) {
      controller.updateEntry(entry.id, result);
    }
  }
}