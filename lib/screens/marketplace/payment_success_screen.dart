import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/cart_controller.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final double totalCost;

  const PaymentSuccessScreen({super.key, required this.totalCost});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final UserController userController = Get.find<UserController>();
    final user = userController.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Payment Success",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16),
              ),
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    cartController.checkoutPhone.value.isNotEmpty
                        ? cartController.checkoutPhone.value
                        : 'No phone provided',
                    style: const TextStyle(fontSize: 16),
                  )),
              const Text(
                'Phone',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    cartController.checkoutAddress.value.isNotEmpty
                        ? cartController.checkoutAddress.value
                        : 'No address provided',
                    style: const TextStyle(fontSize: 16),
                  )),
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    cartController.paymentMethod.value.isNotEmpty
                        ? cartController.paymentMethod.value
                        : 'No payment method',
                    style: const TextStyle(fontSize: 16),
                  )),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Payment Is Successful',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Order Total: \$${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.clearCart();
                        // Reset checkout info if needed
                        cartController.checkoutPhone.value = '';
                        cartController.checkoutAddress.value = '';
                        cartController.paymentMethod.value = '';
                        
                        Get.offAll(() => Marketplace());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Back To Shopping",
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
            const Spacer(),
            const Divider(thickness: 1),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Paid",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${totalCost.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}