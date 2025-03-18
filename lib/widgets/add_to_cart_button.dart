import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/providers/cart_provider.dart';
import 'package:fish_app/models/product.dart';

class AddToCartButton extends StatefulWidget {
  final Product product;
  const AddToCartButton({super.key, required this.product});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        setState(() {
          isAdded = !isAdded;
        });

        if (isAdded) {
          cartProvider.addProduct(widget.product);
        } else {
          cartProvider.removeProduct(widget.product);
        }
      },
      icon: Icon(
        isAdded ? Icons.shopping_cart : Icons.shopping_cart,
        color: isAdded ? const Color.fromARGB(255, 63, 17, 200) : Colors.grey,
      ),
    );
  }
}
