import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_fisica.dart';

class DetalhesPessoaScreen extends StatelessWidget {
  final Map<String, dynamic> pessoa;

  DetalhesPessoaScreen({required this.pessoa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Pessoa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${pessoa['nome']}'),
            Text('CPF: ${pessoa['cpf']}'),
            // Adicione outros campos conforme necessário
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroPessoaFisica(pessoa: pessoa)),
                );
              },
              child: Text('Editar'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection("pessoa_fisica").doc(pessoa['id']).delete().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pessoa deletada com sucesso')),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao deletar pessoa: $error')),
                  );
                });
                // Implemente a lógica para excluir a pessoa
              },
              child: Text('Excluir'),
            ),
          ],
        ),
      ),
    );
  }
}
