import 'package:fish_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalTable extends StatefulWidget {
  const JournalTable({super.key});

  @override
  State<JournalTable> createState() => _JournalTableState();
}

class _JournalTableState extends State<JournalTable> {
  //bech nesta3mlouh fel focusedday
  DateTime today = DateTime.now();
  DateTime? selectedDay;
  //map qui stocke the events created
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  @override
  void initState() {
    super.initState();
    selectedDay = today;
    _selectedEvents = ValueNotifier(_getEventsForDay(today));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(today, selectedDay)) {
      setState(() {
        today = selectedDay;
        focusedDay = focusedDay;
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Code Diary!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text("Event Name"),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(controller: _eventController),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_eventController.text.isNotEmpty) {
                        //ajout l event lel list de la date selectionner
                        events[selectedDay!] = [Event(_eventController.text)];
                        _selectedEvents.value = _getEventsForDay(today);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Submit"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, // Fond bleu clair
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  locale: "en_US",
                  //height meben each day
                  rowHeight: 43,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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

                  //charger les evenements pour chaque jour
                  eventLoader: _getEventsForDay,

                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color:
                          Colors.blue.shade300, // Bleu clair pour aujourd’hui
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color:
                          Colors
                              .blue
                              .shade700, //  Bleu foncé pour le jour sélectionné
                      shape: BoxShape.circle,
                    ),
                  ),

                  //bech ki nenzlou ala ayy day yetselectionilna houwa
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      today = focused; // Mettre à jour le jour focalisé
                    });
                  },
                  onPageChanged: (focusedDay) {
                    today = focusedDay;
                  },
                ),
              ),
              SizedBox(height: 8.0),
              //listes des evenements du jour selectionné
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(Icons.event, color: Colors.blue),
                            title: Text(
                              value[index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Heure: 12:00 - 14:00"),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
