import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/tips/tip_card.dart';
import 'edit_tip_screen.dart';
import 'add_tip_screen.dart';
import '../../controllers/tip_controller.dart'; // Import TipController

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get an instance of TipController
    final TipController controller = Get.put(TipController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips and Tricks'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: Obx(() {
        // Observe the tips list for changes
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: controller.tips.length,
          itemBuilder: (context, index) {
            return TipCardWidget(
              tip: controller.tips[index],
              onEdit: () {
                // Navigate to the edit page with the tip details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTipScreen(
                      tip: controller.tips[index],
                      onUpdate: (updatedTip) {
                        controller.updateTip(index, updatedTip);
                      },
                    ),
                  ),
                );
              },
              onDelete: () {
                // Show delete confirmation
                _showDeleteConfirmation(context, index, controller);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTipScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTipScreen(onAdd: controller.addTip),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index, TipController controller) {
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
                controller.deleteTip(index); // Call delete method
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
