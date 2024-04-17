import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/services/veiculo_service.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';

class PersonCard extends StatelessWidget {

  final String nome;
  final String cpf;
  final String telefone;
  final String id;

  const PersonCard(this.nome, this.cpf, this.telefone, this.id);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: CustomTextLabel(label: nome, fontWeight: FontWeight.bold,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(label: "CPF: $cpf"),
            CustomTextLabel(label: "Telefone: $telefone"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(FontAwesomeIcons.trash, color: ColorsConstants.iconColor,),
          onPressed: () => {
            VeiculoService.deletaVeiculo(id).then((value) {
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

}