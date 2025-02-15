import 'package:flutter/material.dart';

import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';

class RegisterSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterSaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorsConstants.orangeFields),
        child: const Text(GeneralConstants.saveButton,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
  }
}
