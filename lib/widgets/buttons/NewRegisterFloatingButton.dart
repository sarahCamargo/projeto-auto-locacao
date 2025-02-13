import 'package:flutter/material.dart';

class NewRegisterFloatingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NewRegisterFloatingButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 20,
      child: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFED6E33),
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}