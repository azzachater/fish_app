import 'package:flutter/material.dart';

class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedView;
  final Function(String) onViewChange;

  const JournalAppBar({
    super.key,
    required this.selectedView,
    required this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'journal',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              _toggleButton('Day', selectedView == "Day"),
              _toggleButton('Week', selectedView == "Week"),
            ],
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white], // Dégradé plus visible
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => onViewChange(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
