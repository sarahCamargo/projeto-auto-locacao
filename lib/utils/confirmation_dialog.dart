import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';

import '../widgets/text/custom_text_label.dart';


class ConfirmationDialog extends StatefulWidget {
  final String content;
  final Widget confirmationWidget;

  const ConfirmationDialog(
      {super.key,
      required this.content,
      required this.confirmationWidget});

  @override
  ConfirmationDialogState createState() => ConfirmationDialogState();
}

class ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomTextLabel(label: widget.content),
      actions: [widget.confirmationWidget, cancelAction(context)],
    );
  }

  Widget cancelAction(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const CustomTextLabel(
          label: GeneralConstants.cancel,
        ));
  }
}
