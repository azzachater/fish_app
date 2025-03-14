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
  color: Colors.black, // Utilise la couleur principale pour un look moderne
  fontSize: 20, // Taille un peu plus grande pour donner plus de présence
  fontWeight: FontWeight.w700, // FontWeight plus lourd pour plus d'impact
  letterSpacing: 1.2, // Espacement un peu plus serré pour plus de fluidité
  fontFamily: GoogleFonts.poppins().fontFamily, // Une police moderne
);

static final TextStyle chatSenderName = TextStyle(
  color: Colors.white, // Garder le texte en blanc pour le contraste
  fontSize: 22, // Une taille de texte un peu plus grande pour le nom de l'expéditeur
  fontWeight: FontWeight.w600, // Un poids de police plus modéré, mais toujours audacieux
  letterSpacing: 0.5, // Moins d'espacement pour un texte plus compact et moderne
  fontFamily: GoogleFonts.roboto().fontFamily, // Roboto pour un look moderne et lisible
);

static final TextStyle bodyText1 = TextStyle(
  color: Color(0xffA8A9B5), // Une teinte de gris pour un texte plus doux et moderne
  fontSize: 15, // Augmenter légèrement la taille pour plus de confort de lecture
  letterSpacing: 1.1, // Espacement plus naturel
  fontWeight: FontWeight.w400, // Un poids léger et élégant
  fontFamily: GoogleFonts.openSans().fontFamily, // Open Sans est moderne et lisible
);

static final TextStyle bodyTextMessage = TextStyle(
  color: Colors.black, // Texte noir pour un contraste plus net et moderne
  fontSize: 14, // Une taille plus petite pour le message, mais toujours lisible
  letterSpacing: 0.8, // Espacement léger pour plus de fluidité
  fontWeight: FontWeight.w500, // Poids moyen pour une lecture agréable
  fontFamily: GoogleFonts.lato().fontFamily, // Lato, une autre police moderne
);

static final TextStyle bodyTextTime = TextStyle(
  color: Color(0xffA8A9B5), // Utiliser une couleur plus claire pour l'heure
  fontSize: 12, // Plus petite taille pour l'heure, car elle ne doit pas dominer
  fontWeight: FontWeight.w400, // Poids léger pour garder l'heure discrète
  letterSpacing: 0.5, // Un espacement léger pour la clarté
  fontFamily: GoogleFonts.robotoMono().fontFamily, // Pour un look moderne et simple
);
}