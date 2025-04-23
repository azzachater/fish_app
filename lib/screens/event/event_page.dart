import 'package:fish_app/controllers/user_controller.dart';
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
                        Flexible(
                          // Remplace Expanded par Flexible pour meilleure compatibilité
                          child: Text(
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(event.date), // Format simplifié
                            style: TextStyle(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.place, size: 16, color: Colors.grey[700]),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.location,
                            style: TextStyle(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    _buildParticipantsSection(event),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() {
                        final currentUser =
                            Get.find<UserController>().currentUser.value;
                        final isParticipating = event.participants.any(
                          (p) => p.user.id == currentUser?.id,
                        );

                        return ElevatedButton.icon(
                          onPressed:
                              isParticipating
                                  ? null
                                  : () => eventController.joinEvent(index),
                          icon: Icon(Icons.person_add, size: 18),
                          label: Text(
                            isParticipating ? 'Déjà inscrit' : 'Rejoindre',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isParticipating
                                    ? Colors.grey
                                    : Color(0xFF4A8BE5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        );
                      }),
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

  Widget _buildParticipantsSection(Event event) {
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
            children:
                event.participants
                    .map(
                      (participant) => Tooltip(
                        message: participant.user.name,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: _getAvatarProvider(
                            participant.user.avatar,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 8),
        ],
        Text(
          'Total participants: ${event.participants.length}',
          style: TextStyle(
            color: Colors.blue[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  ImageProvider _getAvatarProvider(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    }

    if (avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    } else if (avatarUrl.startsWith('assets/')) {
      return AssetImage(avatarUrl);
    } else {
      // Pour les chemins relatifs sans le préfixe 'assets/'
      return AssetImage('assets/$avatarUrl');
    }
  }
}