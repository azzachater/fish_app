import 'package:fish_app/models/event.dart';
import 'package:fish_app/screens/event/create_event_page.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Événements de Pêche',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF4A8BE5),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Obx(() {
        if (eventController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (eventController.events.isEmpty) {
          return Center(child: Text('Aucun événement disponible'));
        }

        return ListView.builder(
          itemCount: eventController.events.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final event = eventController.events[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border(
                  left: BorderSide(color: Colors.blue.shade300, width: 5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A8BE5),
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('yyyy-MM-dd – HH:mm').format(event.date),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.place, size: 16, color: Colors.grey[700]),
                        SizedBox(width: 4),
                        Text(
                          event.location,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      event.description,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    SizedBox(height: 10),
                    // Section Participants améliorée
                    _buildParticipantsSection(event, index),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Utiliser l'avatar de l'utilisateur connecté
                          final userAvatar = _getUserAvatarUrl();
                          eventController.joinEvent(index, userAvatar);
                        },
                        icon: Icon(Icons.person_add),
                        label: Text('Participer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A8BE5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateEventPage()),
        backgroundColor: Color(0xFF4A8BE5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Icon(Icons.add, size: 28),
      ),
      backgroundColor: Color(0xFFF5F7FB),
    );
  }

  Widget _buildParticipantsSection(Event event, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.participants.isNotEmpty) ...[
          Text(
            'Participants:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...event.participants.map(
                (avatarUrl) => CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
        Text(
          'Total participants: ${event.participants.length}',
          style: TextStyle(color: Colors.blue[600]),
        ),
      ],
    );
  }

  String _getUserAvatarUrl() {
    // À remplacer par l'avatar réel de l'utilisateur connecté
    // Exemple temporaire avec un avatar aléatoire
    return 'https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}';
  }
}
