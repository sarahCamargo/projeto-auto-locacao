import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';

import '../widgets/custom_text_label.dart';

class ConfirmationDialog extends StatefulWidget {
  final String content;
  final String message;
  final Future<void> Function() action;

  const ConfirmationDialog(
      {super.key,
      required this.content,
      required this.action,
      required this.message});

  @override
  ConfirmationDialogState createState() => ConfirmationDialogState();
}

class ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomTextLabel(label: widget.content),
      actions: [confirmationAction(context), cancelAction(context)],
    );
  }

  Widget confirmationAction(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.action().then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.message)),
            );
            Navigator.of(context).pop();
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao realizar ação: $error')),
            );
            Navigator.of(context).pop();
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
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
