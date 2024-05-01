
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';
import '../../utils/confirmation_dialog.dart';
import '../../widgets/custom_text_label.dart';

typedef OnDelete = Future<void> Function(int id);

class CustomCardVehicle extends StatelessWidget {
  final String modelo;
  final String ano;
  final String placa;
  final int id;
  final String? _image;
  final OnDelete? delete;

  const CustomCardVehicle(
      this.modelo, this.ano, this.placa, this.id, this._image, this.delete, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: ListTile(
          title: CustomTextLabel(
            label: modelo,
            fontWeight: FontWeight.bold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextLabel(label: "Ano: $ano"),
              CustomTextLabel(label: "Placa: $placa"),
            ],
          ),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_image),
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
          ),
          trailing: IconButton(
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
          ),
        ),
      ),
    );
  }

  Widget confirmationAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        delete?.call(id).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(GeneralConstants.registerDeleted)),
          );
          Navigator.of(context).pop(true);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao realizar ação: $error')),
          );
          Navigator.of(context).pop();
        });
      },
      child: const CustomTextLabel(
        label: GeneralConstants.ok,
      ),
    );
  }
}
