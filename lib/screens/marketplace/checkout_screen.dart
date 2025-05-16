import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controllers/user_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final UserController userController = Get.find<UserController>();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  CheckoutScreen({super.key}) {
    // Initialiser les contrôleurs avec les valeurs existantes
    phoneController.text = cartController.checkoutPhone.value;
    addressController.text = cartController.checkoutAddress.value;
  }

  @override
  Widget build(BuildContext context) {
    final total = cartController.totalPrice + 60.20;
    final user = userController.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Contact Information
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email (non éditable)
                    _buildInfoCard(
                      icon: Icons.email,
                      title: user.email,
                      subtitle: 'Email',
                    ),
                    const SizedBox(height: 10),

                    // Phone (éditable)
                    _buildEditableField(
                      icon: Icons.phone,
                      controller: phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      onChanged:
                          (value) => cartController.checkoutPhone.value = value,
                    ),

                    // Section Shipping Address
                    const SizedBox(height: 25),
                    const Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Address (éditable)
                    _buildEditableField(
                      icon: Icons.location_on,
                      controller: addressController,
                      label: 'Full Address',
                      hint: 'Enter your shipping address',
                      onChanged:
                          (value) =>
                              cartController.checkoutAddress.value = value,
                      isAddress: true,
                    ),

                    // Section Payment Method
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

                    // Méthode de paiement (sélection)
                    Obx(
                      () => _buildPaymentMethodCard(
                        method: cartController.paymentMethod.value,
                        onTap: () => _showPaymentMethodDialog(context),
                      ),
                    ),

                    // Section Order Summary
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

                    // Bouton de paiement
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Valider les champs requis avant paiement
                          if (_validateCheckoutFields()) {
                            await cartController.placeOrder();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
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

  bool _validateCheckoutFields() {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }

    if (addressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your shipping address');
      return false;
    }

    if (cartController.paymentMethod.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return false;
    }

    return true;
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
          Icon(icon, color: AppTheme.primaryColor),
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String) onChanged,
    bool isAddress = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          suffixIcon: const Icon(Icons.edit, color: Colors.grey),
        ),
        onChanged: onChanged,
        maxLines: isAddress ? 3 : 1,
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String method,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            const Icon(Icons.credit_card, color: AppTheme.primaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                method.isEmpty ? 'Select payment method' : method,
                style: TextStyle(
                  fontSize: 16,
                  color: method.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Payment Method'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Credit Card'),
                  onTap: () {
                    cartController.paymentMethod.value = 'Credit Card';
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.paypal),
                  title: const Text('PayPal'),
                  onTap: () {
                    cartController.paymentMethod.value = 'PayPal';
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('Cash on Delivery'),
                  onTap: () {
                    cartController.paymentMethod.value = 'Cash on Delivery';
                    Get.back();
                  },
                ),
              ],
            ),
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
            color: isTotal ? AppTheme.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }
}