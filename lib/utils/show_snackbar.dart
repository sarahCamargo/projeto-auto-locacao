
import 'package:flutter/material.dart';
import '../widgets/custom_snack_bar.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(message: message),
  );
}