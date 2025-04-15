import 'package:fish_app/controllers/notification_controller.dart';
import 'package:fish_app/controllers/profile_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'screens/Authentification/home_page.dart';
import 'screens/Authentification/login_page.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/event_journal_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/services/api_push_notif_service.dart'; // ajoute cet import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez d'abord PusherService
  await Get.putAsync(() => PusherService().init());

  // Puis les autres contrôleurs
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(() => JournalController());
  Get.put(UserController());
    Get.put(NotificationController()); // Ajoutez cette ligne

  Get.put(ProfileController());


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fish Net',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
      ],
    );
  }
}


