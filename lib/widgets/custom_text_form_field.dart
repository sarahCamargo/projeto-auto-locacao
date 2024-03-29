import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({super.key, required this.controller, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0), // Define o raio das bordas
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}