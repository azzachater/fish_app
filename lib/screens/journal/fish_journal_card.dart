import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FishJournalCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const FishJournalCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            const SizedBox(height: 8),
            _buildLocationText(),
            const SizedBox(height: 12),
            _buildDescriptionText(),
            const SizedBox(height: 12),
            _buildFooterRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          entry['title'] ?? 'Fishing Journal',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          entry['time'] ?? DateFormat('HH:mm').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLocationText() {
    return Text(
      entry['location'] ?? 'Unknown location',
      style: TextStyle(color: Colors.blue[700], fontSize: 14),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      entry['description'] ?? '',
      style: const TextStyle(fontSize: 15),
    );
  }

  Widget _buildFooterRow() {
    return Row(
      children: [
        Chip(
          label: Text(entry['fishType'] ?? 'General'),
          backgroundColor: Colors.blue[100],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
