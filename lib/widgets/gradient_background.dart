import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF72A0F8), // Couleur en haut
            Color(0xFF3366FF), // Couleur en bas
          ],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
