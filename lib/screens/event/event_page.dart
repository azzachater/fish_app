import 'package:fish_app/screens/event/create_event_page.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPage extends StatelessWidget {
  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Événements de Pêche'),
        backgroundColor: const Color.fromARGB(255, 74, 139, 229), // Bleu thème
      ),
      body: Obx(
        () =>
            eventController.events.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: eventController.events.length,
                  itemBuilder: (context, index) {
                    final event = eventController.events[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 74, 139, 229),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${event.date} - ${event.location}',
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                            SizedBox(height: 10),
                            Text(event.description),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                for (var participant in event.participants)
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      'assets/images/participants/avatar.png',
                                    ),
                                  ),
                                SizedBox(width: 10),
                                Text(
                                  'Participants: ${event.participants.length}',
                                  style: TextStyle(color: Colors.blue[600]),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                eventController.joinEvent(index, 'Utilisateur');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Participer'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateEventPage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
