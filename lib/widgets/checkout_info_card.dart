import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';

class CheckoutInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isAddress;

  const CheckoutInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAddress)
                    Text(title, style: const TextStyle(fontSize: 16))
                  else
                    Text(value, style: const TextStyle(fontSize: 16)),
                  if (!isAddress)
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  if (isAddress)
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (isAddress) const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
