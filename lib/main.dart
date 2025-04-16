import 'package:fish_app/controllers/notification_controller.dart';
import 'package:fish_app/controllers/profile_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/auth/signup_page.dart';
import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/add_journal_controller.dart';
import 'package:fish_app/controller/forecast_controller.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/controller/task_controller.dart';
import 'package:fish_app/screens/Authentification/signup_page.dart';
import 'package:fish_app/screens/Authentification/verify_email_page.dart';
import 'package:fish_app/screens/forecast/forecast_view.dart';
import 'package:fish_app/screens/marketplace/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/Authentification/home_page.dart';
import 'screens/Authentification/login_page.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/event_journal_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/services/api_push_notif_service.dart'; // ajoute cet import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController()); // Initialisation correcte du controller
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(EventController());
  Get.put(TaskController());
  Get.put(AddJournalController());
  Get.put(JournalController());
  Get.put(ForecastController());
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
        GetPage(
          name: '/product',
          page: () => ProductDetailPage(product: Get.arguments),
        ),
        GetPage(name: '/forecast', page: () => ForecastView()),
        GetPage(
          name: '/verify-code',
          page:
              () => VerifyCodePage(
                email: Get.arguments['email'],
                userId: Get.arguments['userId'],
              ),
        ),
      ],
    );
  }
}


