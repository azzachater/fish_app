import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelectorController extends GetxController {
  RxList<DateTime> dates =
      List.generate(
        7,
        (index) => DateTime.now().add(Duration(days: index)),
      ).obs;
  RxInt selectedIndex = 0.obs;
  RxMap<String, List<Map<String, String>>> journalsByDate =
      <String, List<Map<String, String>>>{}.obs;

  String get selectedDate =>
      DateFormat('yyyy-MM-dd').format(dates[selectedIndex.value]);

  void selectDate(int index) {
    selectedIndex.value = index;
    update();
  }

  void addJournalEntry(String title, String description) {
    String dateKey = selectedDate;
    if (!journalsByDate.containsKey(dateKey)) {
      journalsByDate[dateKey] = [];
    }
    journalsByDate[dateKey]!.add({
      "title": title,
      "description": description,
      "status": "Enregistré",
      "icon": "🐠",
    });
    update();
  }

  List<Map<String, String>> getJournalForSelectedDate() {
    return journalsByDate[selectedDate] ?? [];
  }
}
