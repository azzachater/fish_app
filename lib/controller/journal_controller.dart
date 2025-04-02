import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class JournalController extends GetxController {
  final RxList<Map<String, dynamic>> _entries = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredEntries =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeEntries();
    filterByDate(DateTime.now());
  }

  void _initializeEntries() {
    _entries.addAll([
      {
        'id': '1',
        'title': 'Brochet',
        'location': 'Lac - Eau calme',
        'fishType': 'Pike',
        'description': 'Vent léger. Observation : Active le matin.',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'time': '08:30',
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Dorade',
        'location': 'Mer - Vagues modérées',
        'fishType': 'Sea Bream',
        'description': 'Appât : crevettes. Bonne prise.',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'time': '14:15',
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Carpe',
        'location': 'Étang - Eau trouble',
        'fishType': 'Carp',
        'description': 'Appât : maïs. Difficile à attraper.',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'time': '16:45',
        'createdAt': DateTime.now().toIso8601String(),
      },
    ]);
  }

  void filterByDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    filteredEntries.assignAll(
      _entries.where((entry) => entry['date'] == dateStr).toList(),
    );
    filteredEntries.sort((a, b) => b['time'].compareTo(a['time']));
  }

  void addEntry(Map<String, dynamic> entry) {
    _entries.add(entry);
    filterByDate(DateFormat('yyyy-MM-dd').parse(entry['date']));
  }

  void updateEntry(String id, Map<String, dynamic> newData) {
    final index = _entries.indexWhere((entry) => entry['id'] == id);
    if (index != -1) {
      _entries[index] = newData;
      filterByDate(DateFormat('yyyy-MM-dd').parse(newData['date']));
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((entry) => entry['id'] == id);
    filterByDate(DateTime.now());
    Get.snackbar(
      'Success',
      'Journal entry deleted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
