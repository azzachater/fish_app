import 'package:fish_app/controller/journal_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelectorController extends GetxController {
  final JournalController journalController = Get.find<JournalController>();

  final RxList<DateTime> dates =
      List.generate(
        7,
        (index) => DateTime.now().add(Duration(days: index)),
      ).obs;

  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(journalController.selectedDate, (date) {
      final index = dates.indexWhere(
        (d) =>
            DateFormat('yyyy-MM-dd').format(d) ==
            DateFormat('yyyy-MM-dd').format(date),
      );
      if (index != -1) {
        selectedIndex.value = index;
      }
    });
  }

  void selectDate(int index) {
    selectedIndex.value = index;
    final selectedDate = dates[index];
    journalController.selectDate(selectedDate);
    journalController.filterByDate(selectedDate);
  }
}
