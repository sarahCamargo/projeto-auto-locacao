import 'package:flutter/material.dart';

class CustomTextLabel extends StatelessWidget {
  final String label;

  const CustomTextLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16.0,
      ),
    );
  }
}