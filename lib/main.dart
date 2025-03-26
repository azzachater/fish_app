import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'screens/Authentification/home_page.dart';
import 'screens/Authentification/login_page.dart';
import 'screens/Authentification/signup_page.dart';
import 'screens/social_network/social_home_page.dart';

void main() {
  Get.put(AuthController()); // Initialisation correcte du controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fish net',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/socialHome', page: () => SocialHomePage()),
      ],
    );
  }
}
