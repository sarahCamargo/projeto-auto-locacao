import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/services/database/database_handler.dart';

import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';
import '../../utils/confirmation_dialog.dart';
import '../../widgets/custom_text_label.dart';
import '../utils/show_snackbar.dart';

typedef OnDelete = Future<void> Function(int id);

class CustomCard extends StatelessWidget {
  final List<Widget> data;
  final String title;
  final int id;
  final bool hasImage;
  final bool hasDelete;
  final String? imageUrl;
  final DatabaseHandler dbHandler;

  const CustomCard(
      {super.key,
      required this.title,
      required this.data,
      required this.id,
      this.hasImage = false,
      this.hasDelete = false,
      this.imageUrl,
      required this.dbHandler});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: ListTile(
          title: CustomTextLabel(
            label: title,
            fontWeight: FontWeight.bold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data,
          ),
          leading: hasImage
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(imageUrl!),
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              FontAwesomeIcons.car,
                              color: ColorsConstants.iconColor,
                            ),
                          ),
                  ),
                )
              : null,
          trailing: hasDelete ? IconButton(
            icon: const Icon(
              FontAwesomeIcons.trash,
              color: ColorsConstants.iconColor,
            ),
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                        content: GeneralConstants.confirmDelete,
                        confirmationWidget: confirmationAction(context));
                  }),
            },
          ) : null,
        ),
      ),
    );
  }

  Widget confirmationAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        dbHandler.delete(id).then((value) {
          showCustomSnackBar(context, GeneralConstants.registerDeleted);
          Navigator.of(context).pop();
        }).catchError((error) {
          showCustomSnackBar(context, '${GeneralConstants.errorInAction}: $error');
          Navigator.of(context).pop();
        });
      },
      child: const CustomTextLabel(
        label: GeneralConstants.ok,
      ),
    );
  }
}
