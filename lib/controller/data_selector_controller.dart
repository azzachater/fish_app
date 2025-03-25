import 'package:get/get.dart';

class DateSelectorController extends GetxController {
  var selectedIndex = 0.obs;
  final List<DateTime> dates = List.generate(
    30,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  void selectDate(int index) {
    selectedIndex.value = index;
  }
}
