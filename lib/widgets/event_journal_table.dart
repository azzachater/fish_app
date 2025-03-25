import 'package:fish_app/controller/event_journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalTable extends StatelessWidget {
  final JournalController controller = Get.put(JournalController());

  JournalTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Code Diary!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text("Add Event"),
              content: TextField(controller: controller.eventController),
              actions: [
                ElevatedButton(
                  onPressed: controller.addEvent,
                  child: const Text("Submit"),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(
                () => TableCalendar(
                  focusedDay: controller.today.value,
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  locale: "en_US",
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.blue,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.blue,
                    ),
                  ),
                  availableGestures: AvailableGestures.all,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  eventLoader: controller.getEventsForDay,
                  selectedDayPredicate:
                      (day) => isSameDay(controller.selectedDay.value, day),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: controller.onDaySelected,
                  onPageChanged:
                      (focusedDay) => controller.today.value = focusedDay,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Obx(() {
                  final events = controller.getEventsForDay(
                    controller.selectedDay.value,
                  );
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.event, color: Colors.blue),
                          title: Text(
                            events[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
