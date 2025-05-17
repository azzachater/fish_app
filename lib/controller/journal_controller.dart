import 'package:fish_app/models/fishingJournal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../service/api_journal_service.dart';

class JournalController extends GetxController {
  final ApiJournalService _apiService = ApiJournalService();
  final RxList<FishingJournal> _entries = <FishingJournal>[].obs;
  final RxList<FishingJournal> filteredEntries = <FishingJournal>[].obs;
  final RxBool useLiveData = false.obs;
  var selectedDate = DateTime.now().obs;
  var currentMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _loadDemoEntries();
    if (useLiveData.value) await _loadApiEntries();
    filterByDate(DateTime.now());
  }

  void _loadDemoEntries() {
    _entries.addAll([
      FishingJournal(
        id: '1',
        title: 'Pêche au brochet',
        location: 'Lac de Montagne',
        speciesCaught: 'Brochet',
        fishingConditions: 'Vent léger',
        notes: 'Leurre rouge efficace',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        time: '08:30',
      ),
      FishingJournal(
        id: '2',
        title: 'Pêche en mer',
        location: 'Côte Atlantique',
        speciesCaught: 'Bar',
        fishingConditions: 'Marée haute',
        notes: 'Appât: calamar',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        time: '14:15',
      ),
    ]);
  }

  Future<void> _loadApiEntries() async {
    try {
      final data = await _apiService.getJournalEntries();
      _entries.assignAll(data.map((e) => FishingJournal.fromJson(e)));
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
      );
    }
  }

  // Mettez à jour la méthode filterByDate
  // Améliorez la méthode filterByDate
  void filterByDate(DateTime date) {
    selectedDate.value = date;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    filteredEntries.assignAll(
      _entries.where((entry) {
        try {
          final entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
          final entryDateStr = DateFormat('yyyy-MM-dd').format(entryDate);
          return entryDateStr == dateStr;
        } catch (e) {
          return false;
        }
      }),
    );

    filteredEntries.sort((a, b) => b.time.compareTo(a.time));
    // Supprimer update() car les Rx variables notifient déjà les changements
  }

  Future<void> toggleDataMode(bool useApi) async {
    useLiveData.value = useApi;
    _entries.clear();
    if (useApi) {
      await _loadApiEntries();
    } else {
      _loadDemoEntries();
    }
    filterByDate(DateTime.now());
  }

  // Modifiez la méthode addEntry :
  Future<void> addEntry(FishingJournal entry) async {
    try {
      if (useLiveData.value) {
        print('🟢 Attempting to add entry to API');
        // Convertir en format compatible API
        final apiData = {
          'title': entry.title,
          'date': entry.date,
          'time': entry.time,
          'location': entry.location,
          'species_caught': entry.speciesCaught,
          'fishing_conditions': entry.fishingConditions,
          'notes': entry.notes,
        };

        final newEntry = await _apiService.createJournalEntry(apiData);
        _entries.add(FishingJournal.fromJson(newEntry));
        Get.snackbar('Succès', 'Entrée ajoutée avec succès');
      } else {
        _entries.add(entry);
      }
      filterByDate(DateFormat('yyyy-MM-dd').parse(entry.date));
    } catch (e) {
      print('🔴 Error adding entry: $e');
      Get.snackbar(
        'Erreur',
        "Échec de l'ajout: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> updateEntry(String id, FishingJournal newData) async {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) {
      Get.snackbar('Erreur', 'Entrée non trouvée');
      return;
    }

    try {
      if (useLiveData.value) {
        print('🟢 Attempting to update entry in API');
        await _apiService.updateJournalEntry(id, newData.toJson());
      }

      // Mise à jour locale seulement après confirmation API (si en mode live)
      _entries[index] = newData;

      // Filtrage et notification
      filterByDate(DateFormat('yyyy-MM-dd').parse(newData.date));
      Get.snackbar(
        'Succès',
        'Entrée mise à jour',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('🔴 Error updating entry: $e');
      Get.snackbar(
        'Erreur',
        'Échec de la mise à jour: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow; // Important pour que l'appelant sache qu'il y a eu une erreur
    }
  }

  Future<void> deleteEntry(String id) async {
    if (useLiveData.value) {
      try {
        await _apiService.deleteJournalEntry(id);
      } catch (e) {
        Get.snackbar('Erreur', 'Échec de la suppression: ${e.toString()}');
        return;
      }
    }
    _entries.removeWhere((e) => e.id == id);
    filterByDate(DateTime.now());
    Get.snackbar('Succès', 'Entrée supprimée');
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    currentMonth.value = DateTime(
      date.year,
      date.month,
    ); // Synchronise le mois courant
    filterByDate(date);
    update(); // Force le rafraîchissement des observateurs
  }

  void goToPreviousMonth() {
    final newMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    currentMonth.value = newMonth;
    selectDate(DateTime(newMonth.year, newMonth.month, 1));
  }

  void goToNextMonth() {
    final newMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    currentMonth.value = newMonth;
    selectDate(DateTime(newMonth.year, newMonth.month, 1));
  }

  String getMonthYearText() {
    return DateFormat.yMMMM().format(currentMonth.value);
  }

  bool hasEntriesForMonth(DateTime month) {
    return _entries.any((entry) {
      try {
        final entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
        return entryDate.year == month.year && entryDate.month == month.month;
      } catch (e) {
        return false;
      }
    });
  }
}
