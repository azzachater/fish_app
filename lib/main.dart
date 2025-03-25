import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/widgets/event_journal_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(CartController());
  Get.put(FavoriteController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}
