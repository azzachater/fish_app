import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/models/event.dart';
import 'package:fish_app/screens/event/create_event_page.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatelessWidget {
  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Événements de Pêche',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 3,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Obx(() {
        if (eventController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (eventController.events.isEmpty) {
          return Center(
            child: Text(
              'Aucun événement disponible',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: AppTheme.textDark),
              ),
            ),
          );
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
                  left: BorderSide(color: AppTheme.primaryColor, width: 5),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              final currentUser =
                                  Get.find<UserController>().currentUser.value;
                              print(
                                'Current User ID: ${currentUser?.id}, Event User ID: ${event.userId}',
                              ); // Debug
                              if (currentUser?.id.toString() ==
                                  event.userId.toString()) {
                                return PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: AppTheme.primaryColor,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Get.to(
                                        () => CreateEventPage(event: event),
                                      );
                                    } else if (value == 'delete') {
                                      _showDeleteDialog(event.id!);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Modifier'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text(
                                          'Supprimer',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ];
                                  },
                                );
                              }
                              return SizedBox.shrink();
                            }),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppTheme.textDark,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(event.date),
                                style: TextStyle(color: AppTheme.textDark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.place,
                              size: 16,
                              color: AppTheme.textDark,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                event.location,
                                style: TextStyle(color: AppTheme.textDark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          event.description,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                        SizedBox(height: 10),
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
                                      : () =>
                                          eventController.joinEvent(event.id!),
                              icon: Icon(Icons.person_add, size: 18),
                              label: Text(
                                isParticipating ? 'Déjà inscrit' : 'Rejoindre',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isParticipating
                                        ? Colors.grey
                                        : AppTheme.primaryColor,
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
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.1),
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: FloatingActionButton(
              onPressed: () => Get.to(() => CreateEventPage()),
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
      backgroundColor: AppTheme.lightPrimary,
    );
  }

  void _showDeleteDialog(String eventId) {
    Get.defaultDialog(
      title: "Confirmer la suppression",
      middleText: "Voulez-vous vraiment supprimer cet événement?",
      textConfirm: "Oui",
      textCancel: "Non",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await Get.find<EventController>().deleteEvent(eventId);
          Get.back();
          Get.snackbar('Succès', 'Événement supprimé');
        } catch (e) {
          Get.snackbar('Erreur', 'Échec de la suppression: ${e.toString()}');
        }
      },
    );
  }

  Widget _buildParticipantsSection(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.participants.isNotEmpty) ...[
          Text(
            'Participants:',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
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
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
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
      return AssetImage('assets/$avatarUrl');
    }
  }
}