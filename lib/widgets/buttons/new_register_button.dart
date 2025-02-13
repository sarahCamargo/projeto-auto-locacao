import 'package:flutter/material.dart';

import '../../constants/colors_constants.dart';

class NewRegisterFloatingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NewRegisterFloatingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 20,
      child: FloatingActionButton.extended(
        backgroundColor: ColorsConstants.orangeFields,
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
