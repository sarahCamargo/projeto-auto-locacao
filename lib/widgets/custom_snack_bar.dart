import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required String message})
      : super(
          content: Text(message),
          duration: const Duration(seconds: 2),
        );
}
