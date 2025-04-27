import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/models/tip_model.dart';
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
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        title: const Text(
          'Tips and Tricks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ), // icône plus moderne
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
                    builder:
                        (context) => EditTipScreen(
                          tip: controller.tips[index],
                          onUpdate: (updatedTip) {
                            controller.updateTip(updatedTip);
                          },
                        ),
                  ),
                );
              },
              onDelete: () {
                // Show delete confirmation
                _showDeleteConfirmation(
                  context,
                  controller.tips[index],
                  controller,
                );
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
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Tip tip,
    TipController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer le conseil"),
          content: const Text("Voulez-vous vraiment supprimer ce conseil ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (tip.id != null) {
                  controller.deleteTip(tip.id!); // ✅ Suppression correcte
                }
              },
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}