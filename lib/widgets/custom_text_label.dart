import 'package:flutter/material.dart';

class CustomTextLabel extends StatelessWidget {
  final String label;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const CustomTextLabel(
      {super.key,
      required this.label,
      this.fontSize = 18.0,
      this.fontWeight = FontWeight.normal,
      this.color = const Color(0xFF1A355B)});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
      textAlign: TextAlign.center,
    );
  }
}
