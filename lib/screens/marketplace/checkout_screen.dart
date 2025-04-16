import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = cartController.totalPrice + 60.20;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              icon: Icons.email,
              title: 'emmanueloyiboke@gmail.com',
              subtitle: 'Email',
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.phone,
              title: '+234-811-732-5298',
              subtitle: 'Phone',
            ),
            const SizedBox(height: 25),
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              icon: Icons.location_on,
              title: '1082 Airport Road, Nigeria',
              subtitle: 'View Map',
              isAddress: true,
            ),
            const SizedBox(height: 25),
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              icon: Icons.credit_card,
              title: 'DbL Card',
              subtitle: '***** 0896.4829',
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 15),
            _buildPriceRow("Subtotal", cartController.totalPrice),
            const SizedBox(height: 10),
            _buildPriceRow("Delivery", 60.20),
            const SizedBox(height: 15),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildPriceRow("Total Cost", total, isTotal: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => PaymentSuccessScreen(totalCost: total));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Complete Payment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isAddress = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isAddress ? Colors.blue : Colors.grey,
                    fontWeight: isAddress ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isAddress) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
