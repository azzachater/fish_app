import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/event_journal_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/screens/map_page.dart';
import 'package:fish_app/widgets/event_journal_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Initialisation des controllers avec GetX
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(() => JournalController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remplace MaterialApp par GetMaterialApp
      debugShowCheckedModeBanner: false,
      home: MapPage(),
    );
  }
}
