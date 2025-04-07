import 'package:fish_app/models/fishingJournal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../service/api_journal_service.dart';

class JournalController extends GetxController {
  final ApiJournalService _apiService = ApiJournalService();
  final RxList<FishingJournal> _entries = <FishingJournal>[].obs;
  final RxList<FishingJournal> filteredEntries = <FishingJournal>[].obs;
  final RxBool useLiveData = false.obs;

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

  void filterByDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    filteredEntries.assignAll(_entries.where((entry) => entry.date == dateStr));
    filteredEntries.sort((a, b) => b.time.compareTo(a.time));
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

  Future<void> addEntry(FishingJournal entry) async {
    if (useLiveData.value) {
      try {
        final newEntry = await _apiService.createJournalEntry(entry.toJson());
        _entries.add(FishingJournal.fromJson(newEntry));
      } catch (e) {
        Get.snackbar('Erreur', 'Échec de l\'ajout: ${e.toString()}');
        return;
      }
    } else {
      _entries.add(entry);
    }
    filterByDate(DateFormat('yyyy-MM-dd').parse(entry.date));
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
}
