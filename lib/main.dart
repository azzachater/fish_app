import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/add_journal_controller.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/controller/task_controller.dart';
import 'package:fish_app/screens/Authentification/signup_page.dart';
import 'package:fish_app/screens/marketplace/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/Authentification/home_page.dart';
import 'screens/Authentification/login_page.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';

void main() {
  Get.put(AuthController()); // Initialisation correcte du controller
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(EventController());
  Get.put(TaskController());
  Get.put(AddJournalController());
  Get.put(CartControllerX());
  Get.put(JournalController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fish Net',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
        GetPage(
          name: '/product',
          page: () => ProductDetailPage(product: Get.arguments),
        ),
      ],
    );
  }
}

/*import 'package:fish_app/controller/add_cart_controller.dart';
import 'package:fish_app/controller/auth_controller.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/controller/task_controller.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/screens/marketplace/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Initialisation des controllers avec GetX
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(EventController());
  Get.put(TaskController());
  Get.put(CartControllerX());
  Get.put(JournalController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remplace MaterialApp par GetMaterialApp
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      getPages: [
        GetPage(
          name: '/product',
          page: () => ProductDetailPage(product: Get.arguments),
        ),
        // Vos autres routes...
      ],
    );
  }
}
*/
