import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';

class JournalController extends GetxController {
  var selectedDay = DateTime.now().obs;
  var today = DateTime.now().obs;
  var events = <DateTime, List<Event>>{}.obs;
  TextEditingController eventController = TextEditingController();

  List<Event> getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    today.value = focused;
  }

  void addEvent() {
    if (eventController.text.isNotEmpty) {
      final eventDay = DateTime(
        selectedDay.value.year,
        selectedDay.value.month,
        selectedDay.value.day,
      );
      events[eventDay] = [
        ...getEventsForDay(eventDay),
        Event(eventController.text),
      ];
      eventController.clear();
      Get.back();
    }
  }
}
