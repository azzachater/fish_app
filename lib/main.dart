import 'package:flutter/material.dart';
//import 'screens/chat/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/theme.dart';
//import 'screens/social_network/edit_profile_page.dart';
//import 'screens/tips_and_tricks/tip_page.dart';
import 'screens/Authentification/home_page.dart';
void main() {
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chattie UI',
      theme: ThemeData(
        primaryColor:  AppTheme.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
  secondary: AppTheme.accentColor,
),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}