import 'package:flutter/material.dart';

class CustomTextLabel extends StatelessWidget {
  final String label;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const CustomTextLabel(
      {super.key,
      required this.label,
      this.fontSize = 16.0,
      this.fontWeight = FontWeight.normal,
      this.color = const Color(0xFF737373)});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }
}
