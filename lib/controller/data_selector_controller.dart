import 'package:fish_app/controller/journal_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelectorController extends GetxController {
  final JournalController journalController = Get.find<JournalController>();
  
  final RxList<DateTime> dates = <DateTime>[].obs;
  final RxInt selectedIndex = 0.obs;
  final Rx<DateTime> currentDisplayedMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    
    // Synchronisation initiale
    _syncWithJournalController();
    
    // Réagit aux changements de mois dans JournalController
    ever(journalController.currentMonth, (month) {
      if (currentDisplayedMonth.value.year != month.year || 
          currentDisplayedMonth.value.month != month.month) {
        goToMonth(month);
      }
    });
    
    // Réagit aux changements de date sélectionnée
    ever(journalController.selectedDate, _selectDateInView);
  }

  void _syncWithJournalController() {
    currentDisplayedMonth.value = journalController.currentMonth.value;
    _generateDaysForMonth(currentDisplayedMonth.value);
    _selectDateInView(journalController.selectedDate.value);
  }

  void _generateDaysForMonth(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    dates.assignAll(
      List.generate(
        lastDay.day,
        (index) => DateTime(month.year, month.month, index + 1),
      ),
    );
  }

  void _selectDateInView(DateTime date) {
    final index = dates.indexWhere((d) => _isSameDate(d, date));
    if (index != -1) selectedIndex.value = index;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void goToMonth(DateTime month) {
    currentDisplayedMonth.value = month;
    _generateDaysForMonth(month);
    _selectDateInView(journalController.selectedDate.value);
    update(); // Force le rafraîchissement
  }

  void goToPreviousMonth() {
    final prevMonth = DateTime(
      currentDisplayedMonth.value.year,
      currentDisplayedMonth.value.month - 1,
      1,
    );
    journalController.goToPreviousMonth(); // Délègue la logique principale
  }

  void goToNextMonth() {
    final nextMonth = DateTime(
      currentDisplayedMonth.value.year,
      currentDisplayedMonth.value.month + 1,
      1,
    );
    journalController.goToNextMonth(); // Délègue la logique principale
  }

  void selectDate(int index) {
    if (index >= 0 && index < dates.length) {
      selectedIndex.value = index;
      journalController.selectDate(dates[index]);
    }
  }
}