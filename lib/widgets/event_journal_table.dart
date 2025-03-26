import 'package:fish_app/controller/event_journal_controller.dart';
import 'package:fish_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalTable extends StatelessWidget {
  final JournalController controller = Get.put(JournalController());

  JournalTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Journal'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [_buildCalendarSection(), _buildUpcomingEventsSection()],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.blue.shade700,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.blue.shade700,
                  ),
                ),
                availableGestures: AvailableGestures.all,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                eventLoader: controller.getEventsForDay,
                selectedDayPredicate:
                    (day) => isSameDay(controller.selectedDay.value, day),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: Colors.red.shade400),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onDaySelected: controller.onDaySelected,
                onPageChanged:
                    (focusedDay) => controller.today.value = focusedDay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              final events = controller.getUpcomingEvents();
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: events.length,
                itemBuilder: (context, index) => _buildEventCard(events[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            _buildEventDate(event.startDate),
            const SizedBox(width: 16),
            _buildEventDetails(event),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDate(DateTime date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            _getMonthAbbreviation(date.month),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          if (event.location != null) ...[
            const SizedBox(height: 4),
            Text(
              event.location!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Add Event"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.eventController,
                decoration: const InputDecoration(labelText: 'Event Title'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      readOnly: true,
                      onTap: () => controller.selectStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.endDateController,
                      decoration: const InputDecoration(labelText: 'End Date'),
                      readOnly: true,
                      onTap: () => controller.selectEndDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: controller.addEvent,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbreviation(date.month)}';
  }
}
