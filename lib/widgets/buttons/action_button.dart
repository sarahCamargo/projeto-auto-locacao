import 'package:flutter/material.dart';

import '../../constants/colors_constants.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsConstants.blueFields, // Cor do botão
        ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18.0),
      )
      //backgroundColor: ColorsConstants.orangeFields,
    );
  }
}
