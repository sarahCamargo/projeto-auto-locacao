import 'package:flutter/cupertino.dart';

import 'custom_text_label.dart';

class RegisterTextLabel extends StatelessWidget {
  final String label;
  final double? fontSize;
  final FontWeight? fontWeight;

  const RegisterTextLabel(
      {super.key,
      required this.label,
      this.fontSize = 14.0,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return CustomTextLabel(
        label: label,
        fontSize: fontSize,
        textAlign: TextAlign.start,
        fontWeight: fontWeight);
  }
}
