import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int selectedIndex = 1;

  final List<Map<String, String>> dates = [
    {"day": "Mon", "date": "29"},
    {"day": "Tue", "date": "30"},
    {"day": "Wed", "date": "01"},
    {"day": "Thu", "date": "02"},
    {"day": "Fri", "date": "03"},
    {"day": "Sat", "date": "04"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70, // Fixe une hauteur pour éviter les erreurs de débordement
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ), // Évite le débordement
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: 50,
              margin: EdgeInsets.symmetric(
                horizontal: 4,
              ), // Moins d'espace pour éviter l'overflow
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]["date"]!,
                    style: TextStyle(
                      fontSize:
                          16, // Réduire la taille du texte pour éviter l’overflow
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    dates[index]["day"]!,
                    style: TextStyle(
                      fontSize: 12, // Réduire la taille du texte
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
