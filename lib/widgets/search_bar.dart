import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          236,
          237,
          237,
        ), // Fond plus clair pour être visible
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade400), // Ajout d'une bordure
      ),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        ),
        style: const TextStyle(color: Colors.black),
        onChanged: onChanged,
      ),
    );
  }
}
