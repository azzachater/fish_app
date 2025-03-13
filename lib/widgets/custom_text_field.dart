import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String? hintText; // Added hintText parameter
  final int maxLines; // Added maxLines parameter

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.hintText,
    this.maxLines = 1, // Default value for maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87)),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          maxLines: maxLines, // Added maxLines
          decoration: InputDecoration(
            hintText: hintText, // Added hintText
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}