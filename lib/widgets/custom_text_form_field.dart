import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final MaskedTextController? maskedController;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? errorText;
  final bool? readOnly;

  const CustomTextField(
      {super.key,
      this.controller,
      this.maskedController,
      this.keyboardType,
      this.hintText,
      this.errorText,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0), // Define o raio das bordas
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller ?? maskedController,
        keyboardType: keyboardType,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          errorText: errorText,
        ),
      ),
    );
  }
}
