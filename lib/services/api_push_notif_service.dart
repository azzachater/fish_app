import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/notification_model.dart';
import '../controllers/notification_controller.dart';
import '../controllers/user_controller.dart';
import '../service/api_auth_service.dart';

class PusherService extends GetxService {
  static PusherService get to => Get.find();

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final ApiAuthService _authService = ApiAuthService();

  bool _isConnected = false;
  bool _isInitialized = false;
  String? _currentChannel;

  Future<PusherService> init() async {
    if (!_isInitialized) {
      await _initPusher();
      _isInitialized = true;
    }
    return this;
  }

  Future<void> _initPusher() async {
    try {
      print('🟠 Initialisation de Pusher...');
      await _pusher.init(
        apiKey: '2798f826b9ce70d037b5',
        cluster: 'eu',
        authEndpoint: 'http://10.0.2.2:8000/api/broadcasting/auth',
        onAuthorizer: _onAuthorizer,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          print('✅ Abonnement réussi au canal $channelName');
          print('Détails de l\'abonnement: $data');
        },
        onSubscriptionError: (String channelName, dynamic error) {
          print('❌ Erreur abonnement canal $channelName: $error');
          if (error is PlatformException) {
            print('Détails de l\'erreur: ${error.message}');
            print('Code: ${error.code}');
            print('Stacktrace: ${error.stacktrace}');
          }
        },
      );
      
      // Configurer le handler d'événements après l'initialisation
      _pusher.onEvent = _handlePusherEvent;
      
      print('🟢 Initialisation de Pusher terminée avec succès');
    } catch (e) {
      print('❌ Erreur initialisation Pusher: $e');
      if (e is PlatformException) {
        print('Détails: ${e.message}, Code: ${e.code}');
      }
      rethrow;
    }
  }

  Future<Map<String, String>> _onAuthorizer(String channelName, String socketId, dynamic options) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Token manquant');

      print('🔑 Authentification pour le canal: $channelName');
      
      final response = await GetConnect().post(
        'http://10.0.2.2:8000/api/broadcasting/auth',
        {
          'socket_id': socketId,
          'channel_name': channelName,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('📦 Réponse de l\'authorizer: ${response.bodyString}');
        
        // Retourner directement la réponse JSON décodée
        final authResponse = jsonDecode(response.bodyString!);
        return authResponse.cast<String, String>();
      } else {
        throw Exception('Erreur authorizer: ${response.statusCode} - ${response.bodyString}');
      }
    } catch (e) {
      print('❌ Erreur authorizer: $e');
      rethrow;
    }
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("📶 État connexion: $previousState ➡ $currentState");
    _isConnected = currentState == 'CONNECTED';

    if (_isConnected && _currentChannel != null) {
      // Réessayer de s'abonner si on se reconnecte
      subscribeToChannel(_currentChannel!);
    }

    if (currentState == 'DISCONNECTED') {
      print('🔴 Pusher déconnecté - Tentative de reconnexion dans 2 secondes');
      Future.delayed(Duration(seconds: 2), () => connect());
    }
  }

  void _onError(String message, int? code, dynamic e) {
    print("❌ Erreur Pusher: $message (Code: $code)");
    if (e != null) {
      print("Détails: $e");
    }
  }

  Future<void> connect() async {
    try {
      final userController = Get.find<UserController>();
      await userController.fetchCurrentUser();
      final currentUser = userController.currentUser.value;

      if (currentUser == null) {
        print('⛔ Aucun utilisateur connecté');
        return;
      }

      if (_pusher.connectionState != "CONNECTED") {
        print('🔌 Connexion au serveur Pusher...');
        await _pusher.connect();
        await Future.delayed(Duration(seconds: 1));
      }

      final privateChannel = 'private-notifications.${currentUser.id}';
      await subscribeToChannel(privateChannel);

    } catch (e) {
      print('❌ Erreur connexion Pusher: $e');
      _isConnected = false;
      Future.delayed(Duration(seconds: 5), () => connect());
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    try {
      if (_pusher.getChannel(channelName) != null) {
        print('ℹ️ Déjà abonné au canal $channelName');
        return;
      }

      print('🔄 Abonnement au canal $channelName');
      await _pusher.subscribe(channelName: channelName);
      _currentChannel = channelName;
      _isConnected = true;
      
      print('✅ Abonnement réussi à $channelName');
    } catch (e) {
      print('❌ Erreur lors de l\'abonnement à $channelName: $e');
      throw e;
    }
  }

  void _handlePusherEvent(PusherEvent event) {
    try {
      print("\n🔔 Événement reçu [${event.channelName}]");
      print("🔖 Nom de l'événement: ${event.eventName}");
      print("📦 Type de données: ${event.data.runtimeType}");
      print("📝 Données brutes: ${event.data}");

      if (event.eventName == 'new-message-notification' && event.data != null) {
        _handleNewNotification(event.data!);
      }
    } catch (e) {
      print('❌ Erreur dans _handlePusherEvent: $e');
    }
  }

  void _handleNewNotification(String eventData) {
  try {
    final data = jsonDecode(eventData);
    final notifController = Get.find<NotificationController>();

    // Conversion sécurisée du receiver_id
    final receiverId = int.tryParse(data['receiver_id'].toString()) ?? 0;

    final notification = NotificationModel(
      id: data['id'] ?? 0,
      senderId: data['sender_id'] ?? 0,
      receiverId: receiverId, // Utilisez la valeur convertie
      message: data['message'] ?? 'Nouveau message',
      type: data['type'] ?? 'message',
      conversationId: data['conversation_id'],
      groupConversationId: data['group_conversation_id'],
      isRead: data['is_read'] == 1,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
    );

    notifController.notifications.insert(0, notification);

    Future.delayed(Duration(milliseconds: 500), () {
  Get.rawSnackbar(
    title: 'Nouvelle notification',
    message: notification.message,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.green[400] ?? Colors.green,
    borderRadius: 10,
    margin: EdgeInsets.all(10),
  );
});


  } catch (e) {
    print('❌ Erreur traitement notification: $e');
    print('Données reçues: ${eventData}');
    print('Stack trace: ${StackTrace.current}');
  }
}

  Future<void> disconnect() async {
    try {
      if (_currentChannel != null) {
        await _pusher.unsubscribe(channelName: _currentChannel!);
        _currentChannel = null;
      }
      await _pusher.disconnect();
      _isConnected = false;
    } catch (e) {
      print('❌ Erreur déconnexion Pusher: $e');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}