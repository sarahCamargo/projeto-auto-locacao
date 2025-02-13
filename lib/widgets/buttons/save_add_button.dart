import 'package:flutter/material.dart';

import '../../constants/colors_constants.dart';

class SaveOrAddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SaveOrAddButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      backgroundColor: ColorsConstants.orangeFields,
    );
  }
}
