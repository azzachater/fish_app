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
    selectedDate.value = date; // Ajoutez cette ligne
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
    update();
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
        final newEntry = await _apiService.createJournalEntry(entry.toJson());
        _entries.add(FishingJournal.fromJson(newEntry));
        Get.snackbar('Succès', 'Entrée ajoutée avec succès');
      } else {
        _entries.add(entry);
      }
      filterByDate(DateFormat('yyyy-MM-dd').parse(entry.date));
      update();
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
    if (index == -1) return;

    if (useLiveData.value) {
      try {
        await _apiService.updateJournalEntry(id, newData.toJson());
        _entries[index] = newData;
      } catch (e) {
        Get.snackbar('Erreur', 'Échec de la mise à jour: ${e.toString()}');
        return;
      }
    } else {
      _entries[index] = newData;
    }
    filterByDate(DateFormat('yyyy-MM-dd').parse(newData.date));
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
    filterByDate(date);
  }

  void goToPreviousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
  }

  void goToNextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
  }

  String getMonthYearText() {
    return DateFormat.yMMMM().format(currentMonth.value);
  }
}
