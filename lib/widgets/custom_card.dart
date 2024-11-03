import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/services/database/database_handler.dart';
import 'package:projeto_auto_locacao/services/notification_service.dart';

import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';
import '../../utils/confirmation_dialog.dart';
import '../../widgets/custom_text_label.dart';
import '../constants/collection_names.dart';
import '../utils/show_snackbar.dart';

typedef OnDelete = Future<void> Function(int id);

class CustomCard extends StatefulWidget {
  final List<Widget> data;
  final String title;
  final int id;
  final bool hasImage;
  final bool hasDelete;
  final String? imageUrl;
  final DatabaseHandler dbHandler;
  final bool hasOptions;
  final VoidCallback? onEdit;
  final VoidCallback? onFinalize;
  final VoidCallback? onGenerateContract;
  final VoidCallback? onRenovateContract;
  final bool isHistory;

  const CustomCard(
      {super.key,
      required this.title,
      required this.data,
      required this.id,
      this.hasImage = false,
      this.hasDelete = false,
      this.imageUrl,
      required this.dbHandler,
      this.hasOptions = false,
      this.onEdit,
      this.onFinalize,
      this.onGenerateContract,
      this.onRenovateContract,
      this.isHistory = false});

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  bool _isOptionsVisible = false;

  void _toggleOptions() {
    setState(() {
      _isOptionsVisible = !_isOptionsVisible;
    });
  }

  void _handleEdit() {
    if (widget.onEdit != null) {
      widget.onEdit!();
    }
  }

  void _handleFinalize() {
    if (widget.onFinalize != null) {
      widget.onFinalize!();
    }
  }

  void _handleGenerateContract() {
    if (widget.onGenerateContract != null) {
      widget.onGenerateContract!();
    }
  }

  void _handleRenovateContract() {
    if (widget.onRenovateContract != null) {
      widget.onRenovateContract!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: CustomTextLabel(
                label: widget.title,
                fontWeight: FontWeight.bold,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.data,
              ),
              leading: widget.hasImage
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: widget.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(widget.imageUrl!),
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
              trailing: widget.hasDelete
                  ? IconButton(
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
                                  confirmationWidget:
                                      confirmationAction(context));
                            }),
                      },
                    )
                  : null,
            ),
            if (widget.hasOptions) ...[
              const Divider(),
              if (_isOptionsVisible) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isHistory) ...[
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Center(
                          child: TextButton(
                            onPressed: _handleRenovateContract,
                            child: const CustomTextLabel(
                              label: 'Renovar Contrato',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Center(
                          child: TextButton(
                            onPressed: _handleGenerateContract,
                            child: const CustomTextLabel(
                              label: 'Gerar Contrato',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Center(
                          child: TextButton(
                            onPressed: _handleEdit,
                            child: const CustomTextLabel(
                              label: 'Editar',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Center(
                          child: TextButton(
                            onPressed: _handleFinalize,
                            child: const CustomTextLabel(
                              label: 'Finalizar',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: IconButton(
                  icon: Icon(
                    _isOptionsVisible
                        ? FontAwesomeIcons.angleUp
                        : FontAwesomeIcons.angleDown,
                    color: ColorsConstants.iconColor,
                    size: 24,
                  ),
                  onPressed: _toggleOptions,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget confirmationAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.dbHandler.delete(widget.id).then((value) {
          if(widget.dbHandler.collection == CollectionNames.maintenance) {
            NotificationService.cancelNotification(widget.id);
          }
          showCustomSnackBar(context, GeneralConstants.registerDeleted);
          Navigator.of(context).pop();
        }).catchError((error) {
          showCustomSnackBar(
              context, '${GeneralConstants.errorInAction}: $error');
          Navigator.of(context).pop();
        });
      },
      child: const CustomTextLabel(
        label: GeneralConstants.ok,
      ),
    );
  }
}
