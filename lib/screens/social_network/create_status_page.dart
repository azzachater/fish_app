import 'package:flutter/material.dart';

class CreateStatusPage extends StatefulWidget {
  const CreateStatusPage({super.key});

  @override
  CreateStatusPageState createState() => CreateStatusPageState();
}

class CreateStatusPageState extends State<CreateStatusPage> {
  String _statusText = '';

  void _submitStatus() {
    if (_statusText.isNotEmpty) {
      // Ici, tu peux enregistrer ou envoyer le statut
      print("Status publié : $_statusText");
      Navigator.pop(context); // Retour à la page précédente après publication
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un statut", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Retirer le texte "Exprime-toi !" ici
            TextField(
              onChanged: (value) {
                setState(() {
                  _statusText = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Écris ton statut ici...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: const Text(
                  "Publier",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
