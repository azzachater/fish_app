import 'package:fish_app/main_screen.dart';
import 'package:fish_app/screens/auth/home_page.dart';
import 'package:fish_app/screens/map_page.dart';
import 'package:fish_app/widgets/journal_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/providers/cart_provider.dart';
import 'package:fish_app/providers/favorite_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MapPage());
  }
}
