import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();
  static const Color primaryColor = Color(0xff0095FF);
  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle subtitleStyle = TextStyle(fontSize: 15, color: Color.fromARGB(255, 186, 150, 150));
  static final TextStyle chatTitle = GoogleFonts.grandHotel(fontSize: 36);
  static const Color unreadChatBG = Color(0xffEE1D1D); // Rouge Notifications
  static const Color accentColor = Color.fromARGB(255, 222, 239, 255);

  static final TextStyle heading2 = TextStyle(
  color: Colors.black, 
  fontSize: 22, // Taille légèrement augmentée pour plus de présence
  fontWeight: FontWeight.bold, // Plus d'impact visuel
  letterSpacing: 0.8, // Espacement plus naturel
  fontFamily: GoogleFonts.nunito().fontFamily, // Style moderne et épuré
);

static final TextStyle chatSenderName = TextStyle(
  color: Colors.white, 
  fontSize: 20, // Légèrement réduit pour un look plus fluide
  fontWeight: FontWeight.w700, // Plus proche du style Messenger
  letterSpacing: 0.3, // Moins d'espacement pour plus de compacité
  fontFamily: GoogleFonts.notoSans().fontFamily, // Style plus naturel et fluide
);

static final TextStyle bodyText1 = TextStyle(
  color: Color(0xffA8A9B5), 
  fontSize: 16, // Augmenté pour plus de lisibilité
  letterSpacing: 1.0, // Espacement plus naturel
  fontWeight: FontWeight.w500, // Plus proche de Facebook et Messenger
  fontFamily: GoogleFonts.mulish().fontFamily, // Optimisé pour le confort de lecture
);

static final TextStyle bodyTextMessage = TextStyle(
  color: Colors.black, 
  fontSize: 15, // Augmenté pour mieux correspondre aux messages Messenger
  letterSpacing: 0.5, // Espacement amélioré pour la lisibilité
  fontWeight: FontWeight.w400, // Texte fluide et lisible
  fontFamily: GoogleFonts.inter().fontFamily, // L'inter fait partie des meilleures polices pour le chat
);

static final TextStyle bodyTextTime = TextStyle(
  color: Color(0xffA8A9B5), 
  fontSize: 13, // Taille légèrement augmentée pour éviter d'être trop petit
  fontWeight: FontWeight.w500, // Meilleure lisibilité sans être trop audacieux
  letterSpacing: 0.2, // Espacement minimal pour ne pas distraire
  fontFamily: GoogleFonts.sourceSans3().fontFamily, // Police adaptée aux petits textes
);
}