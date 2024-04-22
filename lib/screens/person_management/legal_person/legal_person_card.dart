import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/services/dao_service.dart';
import 'package:projeto_auto_locacao/utils/confirmation_dialog.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';

class LegalPersonCard extends StatelessWidget {
  final String companyName;
  final String cnpj;
  final String cellPhone;
  final String tradingName;
  final String id;

  const LegalPersonCard(this.companyName, this.cnpj, this.cellPhone, this.tradingName, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        child: ListTile(
          title: CustomTextLabel(
            label: companyName,
            fontWeight: FontWeight.bold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextLabel(label: "Nome Fantasia: $tradingName"),
              CustomTextLabel(label: "CNPJ: $cnpj"),
              CustomTextLabel(label: "Telefone: $cellPhone"),
            ],
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
                        confirmationWidget: confirmationAction(context)
                    );
                  }),
            },
          ),
        ),
      ),
    );
  }

  Future<void> deletePerson() {
    DaoService daoService = DaoService(collectionName: "pessoa_juridica");
    return daoService.delete(id);
  }

  Widget confirmationAction(BuildContext context) {
    return TextButton(
        onPressed: () {
          deletePerson().then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(GeneralConstants.registerDeleted)),
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
}
