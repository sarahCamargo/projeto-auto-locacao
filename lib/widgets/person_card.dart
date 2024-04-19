import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/services/dao_service.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final String cpf;
  final String cellPhone;
  final String id;

  const PersonCard(this.name, this.cpf, this.cellPhone, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: CustomTextLabel(
          label: name,
          fontWeight: FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(label: "CPF: $cpf"),
            CustomTextLabel(label: "Telefone: $cellPhone"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            FontAwesomeIcons.trash,
            color: ColorsConstants.iconColor,
          ),
          onPressed: () => {
            deletePerson().then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pessoa deletada com sucesso')),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao deletar pessoa: $error')),
              );
            })
          },
        ),
      ),
    );
  }

  Future<void> deletePerson() {
    DaoService daoService = DaoService(collectionName: "pessoa_fisica");
    return daoService.delete(id);
  }
}
