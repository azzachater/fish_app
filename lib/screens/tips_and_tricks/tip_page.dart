import 'package:flutter/material.dart';
import '../../data/tip_data.dart';
import '../../widgets/tips/tip_card.dart';
import 'edit_tip_screen.dart';
import 'add_tip_screen.dart';
import '../../models/tip_model.dart'; // Import Tip model

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  TipsPageState createState() => TipsPageState();
}

class TipsPageState extends State<TipsPage> {
  // Method to delete a tip from the list
  void deleteTip(int index) {
    setState(() {
      tips.removeAt(index); // Remove the tip at the given index
    });
  }

  // Method to add a new tip to the list
  void addTip(Tip tip) {
    setState(() {
      tips.add(tip); // Add a new tip to the list
    });
  }

  // Method to update a tip
  void updateTip(int index, Tip updatedTip) {
    setState(() {
      tips[index] = updatedTip; // Update the tip at the given index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips and Tricks'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return TipCardWidget(
            tip: tips[index],
            onEdit: () {
              // Navigate to the edit page with the tip details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTipScreen(
                    tip: tips[index],
                    onUpdate: (updatedTip) {
                      updateTip(index, updatedTip); // Call update callback
                    },
                  ),
                ),
              );
            },
            onDelete: () {
              // Show delete confirmation
              _showDeleteConfirmation(context, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTipScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTipScreen(onAdd: addTip),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Tip"),
          content: const Text("Do you really want to delete this tip?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                deleteTip(index); // Call the delete method
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
