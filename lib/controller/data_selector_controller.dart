import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelectorController extends GetxController {
  RxList<DateTime> dates =
      List.generate(
        7,
        (index) => DateTime.now().add(Duration(days: index)),
      ).obs;

  RxInt selectedIndex = 0.obs;

  // RxMap avec une liste d'entrées par date
  RxMap<String, List<Map<String, String>>> journalsByDate =
      <String, List<Map<String, String>>>{}.obs;

  // Récupérer la date sélectionnée au format 'yyyy-MM-dd'
  String get selectedDate =>
      DateFormat('yyyy-MM-dd').format(dates[selectedIndex.value]);

  // Changer la date sélectionnée
  void selectDate(int index) {
    selectedIndex.value = index;
  }

  // Ajouter une nouvelle entrée dans le journal
  void addJournalEntry(String title, String description) {
    String dateKey = selectedDate;
    if (!journalsByDate.containsKey(dateKey)) {
      journalsByDate[dateKey] = <Map<String, String>>[];
    }
    // Ajouter l'entrée à la liste
    journalsByDate[dateKey]!.add({
      "title": title,
      "description": description,
      "status": "Enregistré",
      "icon": "🐠",
    });
  }

  // Récupérer les entrées pour la date sélectionnée
  List<Map<String, String>> getJournalForSelectedDate() {
    return journalsByDate[selectedDate] ?? [];
  }
}
